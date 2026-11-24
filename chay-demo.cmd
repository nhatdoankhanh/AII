@echo off
setlocal
cd /d "%~dp0"
set "PYTHONUTF8=1"
set "OLLAMA_HOST=127.0.0.1:11434"
set "OLLAMA_MODELS=%~dp0local\models"
call "%~dp0config\ollama-demo.cmd"
if not exist "local" mkdir "local"
if exist "local\ollama\ollama.exe" powershell -NoProfile -Command "try { $null=Invoke-RestMethod 'http://127.0.0.1:11434/api/version' -TimeoutSec 2 -ErrorAction Stop } catch { Start-Process -FilePath '.\local\ollama\ollama.exe' -ArgumentList 'serve' -WindowStyle Hidden }"
if exist "local\neo4j-community-5.26.0\bin\neo4j.bat" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0chuan-bi-neo4j.ps1"
powershell -NoProfile -Command "try { $r=Invoke-RestMethod 'http://127.0.0.1:7860/api/status' -TimeoutSec 6 -ErrorAction Stop; if ($null -ne $r.expected) {exit 0} } catch {}; exit 1"
if not errorlevel 1 goto open
powershell -NoProfile -Command "$p=Start-Process -FilePath (Get-Command python.exe).Source -ArgumentList 'main.py' -WorkingDirectory (Get-Location).Path -WindowStyle Hidden -RedirectStandardError 'local\demo-errors.log' -PassThru; for($i=0;$i -lt 45;$i++){try{$r=Invoke-WebRequest -UseBasicParsing 'http://127.0.0.1:7860/' -TimeoutSec 1 -ErrorAction Stop; if($r.StatusCode -eq 200){exit 0}} catch {}; if($p.HasExited){break};Start-Sleep -Seconds 1};exit 1"
if errorlevel 1 goto failed
:open
start "" "http://127.0.0.1:7860/"
exit /b 0
:failed
echo Xem local\demo-errors.log de kiem tra loi khoi dong.
pause
exit /b 1

