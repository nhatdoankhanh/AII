$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$version = '5.26.0'
$dbRoot = Join-Path $PSScriptRoot "local\neo4j-community-$version"
$zipPath = Join-Path $PSScriptRoot "local\neo4j-community-$version.zip"
$secretPath = Join-Path $PSScriptRoot 'local\neo4j-password.txt'
New-Item -ItemType Directory -Force (Join-Path $PSScriptRoot 'local') | Out-Null

function Receive-File($url, $destination) {
    if (Test-Path -LiteralPath $destination) { return }
    & curl.exe -fLSs --retry 2 --connect-timeout 10 --output "$destination.part" $url
    if ($LASTEXITCODE -ne 0) { throw "Tai that bai: $url" }
    if ($destination.EndsWith('.pdf')) {
        $stream = [IO.File]::OpenRead("$destination.part")
        try { $magic = New-Object byte[] 5; [void]$stream.Read($magic,0,5) } finally { $stream.Dispose() }
        if ([Text.Encoding]::ASCII.GetString($magic) -ne '%PDF-') { throw "Nguon khong tra ve PDF: $url" }
    }
    Move-Item -LiteralPath "$destination.part" -Destination $destination
}

$urls = @(Get-Content -Encoding UTF8 'sources\pdf\sources.txt' | Where-Object { $_ -like 'https://*' })
$names = @('bo-y-te-5481-2020.pdf','niddk-4-steps.pdf')
for ($i = 0; $i -lt $names.Length; $i++) {
    try { Receive-File $urls[$i] (Join-Path $PSScriptRoot ("sources\pdf\" + $names[$i])) } catch { Write-Warning $_ }
}
if (-not (Test-Path (Join-Path $dbRoot 'bin\neo4j.bat'))) {
    Receive-File "https://dist.neo4j.org/neo4j-community-$version-windows.zip" $zipPath
    Expand-Archive -LiteralPath $zipPath -DestinationPath (Join-Path $PSScriptRoot 'local') -Force
}
$env:NEO4J_HOME = $dbRoot
if (!(Test-Path $secretPath)) {
    $secret = [guid]::NewGuid().ToString('N')
    & (Join-Path $dbRoot 'bin\neo4j-admin.bat') dbms set-initial-password $secret
    if ($LASTEXITCODE -ne 0) { throw 'Loi khoi tao Neo4j. Kiem tra Java 17 hoac 21.' }
    [IO.File]::WriteAllText($secretPath,$secret)
}
$conf = Join-Path $dbRoot 'conf\neo4j.conf'
if (!(Select-String -Quiet -LiteralPath $conf -Pattern '^# Diabetes AI demo$')) {
    Add-Content -Encoding ASCII -Path $conf -Value @'

# Diabetes AI demo
server.http.listen_address=127.0.0.1:17474
server.http.advertised_address=localhost:17474
server.bolt.listen_address=127.0.0.1:17687
server.bolt.advertised_address=localhost:17687
server.memory.heap.initial_size=128m
server.memory.heap.max_size=384m
server.memory.pagecache.size=128m
'@
}
function DbReady {
    try { return (Invoke-WebRequest -UseBasicParsing 'http://127.0.0.1:17474/' -TimeoutSec 2).StatusCode -eq 200 } catch { return $false }
}
if (!(DbReady)) {
    Start-Process -FilePath (Join-Path $dbRoot 'bin\neo4j.bat') -ArgumentList 'console' -WorkingDirectory $dbRoot -WindowStyle Hidden
    for ($i=0; $i -lt 60; $i++) { if (DbReady) { break }; Start-Sleep -Seconds 2 }
}
if (!(DbReady)) { throw "Neo4j chua san sang. Kiem tra $dbRoot\logs\neo4j.log" }
python -m knowledge_base.graph --load
if ($LASTEXITCODE -ne 0) { throw 'Khong nap duoc do thi.' }

