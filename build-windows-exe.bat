@echo off
setlocal enabledelayedexpansion
title XER'S VIP STORE - Windows .EXE Builder

echo ==============================================================
echo       XER'S VIP STORE - NATIVE WINDOWS .EXE BUILDER
echo ==============================================================
echo.
echo [*] Checking Environment...

cd /d "%~dp0"

:: 1. Check Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] Warning: Node.js was not found in PATH.
    echo     Please install Node.js from https://nodejs.org/
    echo.
) else (
    echo [+] Node.js detected:
    node -v
)

:: 2. Find C# Compiler (csc.exe from .NET Framework)
set "CSC="
if exist "%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\csc.exe" (
    set "CSC=%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
) else if exist "%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\csc.exe" (
    set "CSC=%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\csc.exe"
)

if not defined CSC (
    echo [!] csc.exe not found directly. Will use PowerShell C# Compiler fallback.
) else (
    echo [+] Found Windows C# Compiler: %CSC%
)

:: 3. Prepare output directory
if not exist "bin" mkdir "bin"

echo.
echo [*] Step 1/3: Compiling XER-VIP-Store-User.exe (Customer Storefront)...

:: Write C# source for User App
(
echo using System;
echo using System.Diagnostics;
echo using System.IO;
echo using System.Net.Sockets;
echo using System.Threading;
echo namespace XerVipStore {
echo     static class UserApp {
echo         [STAThread]
echo         static void Main(string[] args) {
echo             string dir = AppDomain.CurrentDomain.BaseDirectory;
echo             if (File.Exists(Path.Combine(dir, "server.js"))) {}
echo             else if (File.Exists(Path.Combine(dir, "..", "server.js"))) { dir = Path.GetFullPath(Path.Combine(dir, "..")); }
echo             EnsureServer(dir);
echo             LaunchApp("http://localhost:3000/user.html", "XER'S VIP STORE");
echo         }
echo         static bool IsListening() {
echo             try {
echo                 using (var c = new TcpClient()) {
echo                     var res = c.BeginConnect("127.0.0.1", 3000, null, null);
echo                     bool ok = res.AsyncWaitHandle.WaitOne(700);
echo                     if (ok) { c.EndConnect(res); return true; }
echo                     return false;
echo                 }
echo             } catch { return false; }
echo         }
echo         static void EnsureServer(string dir) {
echo             if (IsListening()) return;
echo             string sjs = Path.Combine(dir, "server.js");
echo             if (File.Exists(sjs)) {
echo                 var psi = new ProcessStartInfo {
echo                     FileName = "cmd.exe",
echo                     Arguments = "/c node \"" + sjs + "\"",
echo                     WorkingDirectory = dir,
echo                     WindowStyle = ProcessWindowStyle.Hidden,
echo                     CreateNoWindow = true,
echo                     UseShellExecute = true
echo                 };
echo                 Process.Start(psi);
echo                 for (int i = 0; i < 25; i++) {
echo                     Thread.Sleep(250);
echo                     if (IsListening()) break;
echo                 }
echo             }
echo         }
echo         static void LaunchApp(string url, string title) {
echo             string[] paths = new string[] {
echo                 Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), @"Microsoft\Edge\Application\msedge.exe"),
echo                 Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles(x86)), @"Microsoft\Edge\Application\msedge.exe"),
echo                 Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), @"Google\Chrome\Application\chrome.exe"),
echo                 Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles(x86)), @"Google\Chrome\Application\chrome.exe"),
echo                 Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), @"Google\Chrome\Application\chrome.exe"),
echo                 Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), @"Microsoft\Edge\Application\msedge.exe")
echo             };
echo             foreach (var p in paths) {
echo                 if (File.Exists(p)) {
echo                     var psi = new ProcessStartInfo {
echo                         FileName = p,
echo                         Arguments = "--app=\"" + url + "\" --window-size=1280,840 --name=\"" + title + "\"",
echo                         UseShellExecute = false
echo                     };
echo                     Process.Start(psi);
echo                     return;
echo                 }
echo             }
echo             Process.Start(new ProcessStartInfo(url) { UseShellExecute = true });
echo         }
echo     }
echo }
) > "bin\_UserApp.cs"

if defined CSC (
    "%CSC%" /target:winexe /optimize+ /out:"bin\XER-VIP-Store-User.exe" "bin\_UserApp.cs" >nul 2>nul
) else (
    powershell -NoProfile -Command "Add-Type -TypeDefinition (Get-Content 'bin\_UserApp.cs' -Raw) -OutputAssembly 'bin\XER-VIP-Store-User.exe' -OutputType WindowsApplication"
)

if exist "bin\XER-VIP-Store-User.exe" (
    echo [+] Successfully created: bin\XER-VIP-Store-User.exe
    copy /y "bin\XER-VIP-Store-User.exe" "XER-VIP-Store-User.exe" >nul
    echo [+] Copied launcher to root: XER-VIP-Store-User.exe
) else (
    echo [!] Compilation notice: Creating standalone Windows script launcher...
    (
        echo @echo off
        echo cd /d "%%~dp0"
        echo start "" "http://localhost:3000/user.html"
    ) > "XER-VIP-Store-User.bat"
)
del /f /q "bin\_UserApp.cs" 2>nul

echo.
echo [*] Step 2/3: Compiling XER-VIP-Store-Admin.exe (Admin Console)...

:: Write C# source for Admin App
(
echo using System;
echo using System.Diagnostics;
echo common using System.IO;
echo using System.Net.Sockets;
echo using System.Threading;
echo namespace XerVipStore {
echo     static class AdminApp {
echo         [STAThread]
echo         static void Main(string[] args) {
echo             string dir = AppDomain.CurrentDomain.BaseDirectory;
echo             if (File.Exists(Path.Combine(dir, "server.js"))) {}
echo             else if (File.Exists(Path.Combine(dir, "..", "server.js"))) { dir = Path.GetFullPath(Path.Combine(dir, "..")); }
echo             EnsureServer(dir);
echo             LaunchApp("http://localhost:3000/admin.html", "XER'S VIP ADMIN");
echo         }
echo         static bool IsListening() {
echo             try {
echo                 using (var c = new TcpClient()) {
echo                     var res = c.BeginConnect("127.0.0.1", 3000, null, null);
echo                     bool ok = res.AsyncWaitHandle.WaitOne(700);
echo                     if (ok) { c.EndConnect(res); return true; }
echo                     return false;
echo                 }
echo             } catch { return false; }
echo         }
echo         static void EnsureServer(string dir) {
echo             if (IsListening()) return;
echo             string sjs = Path.Combine(dir, "server.js");
echo             if (File.Exists(sjs)) {
echo                 var psi = new ProcessStartInfo {
echo                     FileName = "cmd.exe",
echo                     Arguments = "/c node \"" + sjs + "\"",
echo                     WorkingDirectory = dir,
echo                     WindowStyle = ProcessWindowStyle.Hidden,
echo                     CreateNoWindow = true,
echo                     UseShellExecute = true
echo                 };
echo                 Process.Start(psi);
echo                 for (int i = 0; i < 25; i++) {
echo                     Thread.Sleep(250);
echo                     if (IsListening()) break;
echo                 }
echo             }
echo         }
echo         static void LaunchApp(string url, string title) {
echo             string[] paths = new string[] {
echo                 Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), @"Microsoft\Edge\Application\msedge.exe"),
echo                 Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles(x86)), @"Microsoft\Edge\Application\msedge.exe"),
echo                 Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), @"Google\Chrome\Application\chrome.exe"),
echo                 Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles(x86)), @"Google\Chrome\Application\chrome.exe"),
echo                 Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), @"Google\Chrome\Application\chrome.exe"),
echo                 Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), @"Microsoft\Edge\Application\msedge.exe")
echo             };
echo             foreach (var p in paths) {
echo                 if (File.Exists(p)) {
echo                     var psi = new ProcessStartInfo {
echo                         FileName = p,
echo                         Arguments = "--app=\"" + url + "\" --window-size=1366,860 --name=\"" + title + "\"",
echo                         UseShellExecute = false
echo                     };
echo                     Process.Start(psi);
echo                     return;
echo                 }
echo             }
echo             Process.Start(new ProcessStartInfo(url) { UseShellExecute = true });
echo         }
echo     }
echo }
) > "bin\_AdminApp.cs"

:: Fix syntax in generated cs
powershell -NoProfile -Command "(Get-Content 'bin\_AdminApp.cs') -replace 'common using', 'using' | Set-Content 'bin\_AdminApp.cs'"

if defined CSC (
    "%CSC%" /target:winexe /optimize+ /out:"bin\XER-VIP-Store-Admin.exe" "bin\_AdminApp.cs" >nul 2>nul
) else (
    powershell -NoProfile -Command "Add-Type -TypeDefinition (Get-Content 'bin\_AdminApp.cs' -Raw) -OutputAssembly 'bin\XER-VIP-Store-Admin.exe' -OutputType WindowsApplication"
)

if exist "bin\XER-VIP-Store-Admin.exe" (
    echo [+] Successfully created: bin\XER-VIP-Store-Admin.exe
    copy /y "bin\XER-VIP-Store-Admin.exe" "XER-VIP-Store-Admin.exe" >nul
    echo [+] Copied launcher to root: XER-VIP-Store-Admin.exe
) else (
    echo [!] Compilation notice: Creating standalone Windows script launcher...
    (
        echo @echo off
        echo cd /d "%%~dp0"
        echo start "" "http://localhost:3000/admin.html"
    ) > "XER-VIP-Store-Admin.bat"
)
del /f /q "bin\_AdminApp.cs" 2>nul

echo.
echo [*] Step 3/3: Creating One-Click Local Server Launcher...

(
echo @echo off
echo title XER'S VIP STORE - Server Engine
echo cd /d "%%~dp0"
echo ==============================================================
echo        XER'S VIP STORE - LIVE SERVER (PORT 3000)
echo ==============================================================
echo.
echo [*] Starting Node.js backend server...
echo [*] User Storefront : http://localhost:3000/user.html
echo [*] Admin Console   : http://localhost:3000/admin.html
echo.
echo Press CTRL+C to stop the server at any time.
echo.
node server.js
pause
) > "start-server.bat"

echo [+] Created start-server.bat

echo.
echo ==============================================================
echo                    BUILD COMPLETED SUCCESSFULLY!
echo ==============================================================
echo.
echo Executable Files Generated:
echo  1. XER-VIP-Store-User.exe  - Double click to open User Storefront!
echo  2. XER-VIP-Store-Admin.exe - Double click to open Admin Console!
echo  3. start-server.bat        - Starts the backend server directly
echo.
echo Note: When you launch XER-VIP-Store-User.exe or Admin.exe,
echo it will automatically boot the server if it's not already running!
echo ==============================================================
echo.
pause
