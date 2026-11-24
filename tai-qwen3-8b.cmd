@echo off
setlocal
pushd "%~dp0" || exit /b 1
set "OLLAMA_HOST=127.0.0.1:11434"
set "OLLAMA_MODELS=%~dp0local\models"
call "%~dp0config\ollama-demo.cmd"
set "QWEN_DIR=%~dp0local\ollama"
set "QWEN_EXE=%QWEN_DIR%\ollama.exe"

if exist "%QWEN_EXE%" goto server
if exist "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" (
    set "QWEN_EXE=%LOCALAPPDATA%\Programs\Ollama\ollama.exe"
    goto server
)
where ollama.exe >nul 2>&1
if not errorlevel 1 (
    for %%I in (ollama.exe) do set "QWEN_EXE=%%~$PATH:I"
    goto server
)

echo Dang tai Ollama cho Windows...
if not exist "%QWEN_DIR%" mkdir "%QWEN_DIR%"
if not exist "%QWEN_DIR%" goto failed
curl.exe --fail --location --show-error --retry 2 --connect-timeout 10 --continue-at - --output "%QWEN_DIR%\ollama-windows-amd64.zip" "https://github.com/ollama/ollama/releases/latest/download/ollama-windows-amd64.zip"
if errorlevel 1 goto failed
powershell.exe -NoProfile -Command "$ErrorActionPreference='Stop'; Expand-Archive -LiteralPath (Join-Path $env:QWEN_DIR 'ollama-windows-amd64.zip') -DestinationPath $env:QWEN_DIR -Force"
if errorlevel 1 goto failed
if not exist "%QWEN_EXE%" goto failed

:server
powershell.exe -NoProfile -Command "function Ready { try { return [bool](Invoke-RestMethod 'http://127.0.0.1:11434/api/version' -TimeoutSec 2 -ErrorAction Stop).version } catch { return $false } }; if (Ready) { exit 0 }; $p = Start-Process -FilePath $env:QWEN_EXE -ArgumentList 'serve' -WindowStyle Hidden -PassThru; for ($i=0; $i -lt 30; $i++) { Start-Sleep -Seconds 1; if (Ready) { exit 0 }; if ($p.HasExited) { break } }; exit 1"
if errorlevel 1 goto failed
echo Dang tai qwen3:8b...
"%QWEN_EXE%" pull qwen3:8b
if errorlevel 1 goto failed
echo Dang thu mot cau hoi tieng Viet...
"%QWEN_EXE%" run --think=false qwen3:8b "Hay chao nguoi dung bang mot cau tieng Viet co dau."
if errorlevel 1 goto failed
echo Da tai va chay thu qwen3:8b.
pause
popd
exit /b 0

:failed
echo Chua hoan tat. Xem thong bao loi phia tren.
pause
popd
exit /b 1
