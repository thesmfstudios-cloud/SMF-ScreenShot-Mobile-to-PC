@echo off
setlocal

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please right-click this file and choose "Run as administrator".
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-SmbShare -Name 'PhoneScreenshots' -ErrorAction SilentlyContinue | Remove-SmbShare -Force"

echo.
echo PhoneScreenshots SMB share removed.
echo The local screenshots folder is NOT deleted.
echo.
pause
endlocal
