@echo off
setlocal EnableExtensions
cd /d "%~dp0.."

set "TARGET=%~dp0..\screenshots"
set "SHARE=PhoneScreenshots"
set "WINUSER=%USERNAME%"

if not exist "%TARGET%" mkdir "%TARGET%"

echo.
echo ==========================================
echo   SMF Screenshot - SMB Setup
echo ==========================================
echo Folder: %TARGET%
echo Share : %SHARE%
echo User  : %WINUSER%
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Please right-click this file and choose:
    echo        Run as administrator
    echo.
    pause
    exit /b 1
)

echo Removing old share if it exists...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-SmbShare -Name '%SHARE%' -ErrorAction SilentlyContinue | Remove-SmbShare -Force" >nul 2>&1

echo Creating SMB share...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = (Resolve-Path '%TARGET%').Path; New-SmbShare -Name '%SHARE%' -Path $p -ChangeAccess $env:USERNAME -ErrorAction Stop | Out-Null"
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Could not create the SMB share.
    echo.
    echo Try this in an elevated PowerShell window:
    echo   Get-SmbShare -Name PhoneScreenshots
    echo.
    pause
    exit /b 1
)

echo Enabling Windows File and Printer Sharing firewall rules...
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes >nul 2>&1

echo.
echo ==========================================
echo   SMB SHARE READY
echo ==========================================
echo.
echo PC IP:
ipconfig | findstr /R /C:"IPv4 Address" /C:"IPv4 Address. . . . . . . . . . ."
echo.
echo Network path:
echo   \YOUR-PC-IP\PhoneScreenshots
echo.
echo Windows username:
echo   %WINUSER%
echo.
echo FolderSync SMB settings:
echo   Server: YOUR-PC-IP
echo   Port:   445
echo   Share:  PhoneScreenshots
echo.
echo Keep the phone and PC on the same Wi-Fi.
echo.
pause
endlocal
