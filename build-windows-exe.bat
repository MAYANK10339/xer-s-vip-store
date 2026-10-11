@echo off
setlocal
cd /d "%~dp0"
title XER'S VIP STORE - Windows .EXE Builder

echo ==============================================================
echo       XER'S VIP STORE - NATIVE WINDOWS .EXE BUILDER
echo ==============================================================
echo.
echo [*] Launching Native Windows Compiler (PowerShell / .NET)...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build-exe.ps1"

echo.
if exist "%~dp0XER-VIP-Store-User.exe" (
    echo [+] XER-VIP-Store-User.exe  is ready in this folder!
)
if exist "%~dp0XER-VIP-Store-Admin.exe" (
    echo [+] XER-VIP-Store-Admin.exe is ready in this folder!
)

echo.
echo Press any key to exit...
pause >nul
