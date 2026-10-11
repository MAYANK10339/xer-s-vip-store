@echo off
setlocal enabledelayedexpansion
title XER'S VIP STORE - Android APK Builder

echo ==============================================================
echo       XER'S VIP STORE - ANDROID .APK BUILDER (USER & ADMIN)
echo ==============================================================
echo.
echo [*] Checking Tools and Environment...
echo.

cd /d "%~dp0"

:: 1. Check Node.js & npm
where npm >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] npm was not found. Please ensure Node.js is installed.
) else (
    echo [+] Node.js / NPM detected.
)

:: 2. Check Java / JDK
set "HAS_JAVA=0"
where java >nul 2>nul
if %errorlevel% equ 0 (
    set "HAS_JAVA=1"
    echo [+] Java JDK detected:
    java -version 2>&1 | findstr /i "version"
) else (
    echo [-] Java JDK not found in PATH (Optional for Capacitor/Gradle build).
)

:: 3. Prepare Android Project Structure
if not exist "android-build" mkdir "android-build"
if not exist "dist-apk" mkdir "dist-apk"

echo.
echo ==============================================================
echo  Choose your preferred method to build Android APK:
echo ==============================================================
echo  [1] Capacitor / WebView Native Wrapper (Standard APK generation)
echo  [2] Bubblewrap CLI / TWA (Google Play & Direct APK Builder)
echo  [3] Generate Ready-to-Compile Android Studio Projects (User & Admin)
echo  [4] Instant 1-Tap PWA Install Method (No SDK required - 100%% native feel)
echo ==============================================================
set /p METHOD="Enter choice (1, 2, 3, or 4) [Default: 3]: "
if "%METHOD%"=="" set METHOD=3

if "%METHOD%"=="1" goto METHOD_CAPACITOR
if "%METHOD%"=="2" goto METHOD_BUBBLEWRAP
if "%METHOD%"=="3" goto METHOD_TEMPLATES
if "%METHOD%"=="4" goto METHOD_PWA

:METHOD_CAPACITOR
echo.
echo [*] Installing Capacitor CLI...
call npm install --save-dev @capacitor/core @capacitor/cli @capacitor/android
echo.
echo [*] Initializing Capacitor for XER'S VIP STORE...
call npx cap init "XERS VIP STORE" "com.xvip.store" --web-dir "public"
echo [*] Adding Android Platform...
call npx cap add android
echo.
echo [*] Building project...
call npx cap sync android
echo.
echo [+] Android Project created inside 'android/' directory!
if "%HAS_JAVA%"=="1" (
    echo [*] Compiling debug APK via Gradle...
    cd android
    call gradlew assembleDebug
    cd ..
    if exist "android\app\build\outputs\apk\debug\app-debug.apk" (
        copy /y "android\app\build\outputs\apk\debug\app-debug.apk" "dist-apk\XER-VIP-Store-User.apk"
        echo [+] APK Generated successfully: dist-apk\XER-VIP-Store-User.apk
    )
) else (
    echo [!] Java JDK / Android SDK is required to run gradlew assembleDebug.
    echo     You can open the generated 'android' folder in Android Studio and click 'Build APK'.
)
goto FINISH

:METHOD_BUBBLEWRAP
echo.
echo [*] Running Bubblewrap PWA packager...
call npx @bubblewrap/cli init --manifest=http://localhost:3000/manifest.json
call npx @bubblewrap/cli build
goto FINISH

:METHOD_TEMPLATES
echo.
echo [*] Generating Android Native WebView Projects for User & Admin...

:: Generate User App Android Project
mkdir "android-build\user-app\app\src\main\java\com\xvip\store" 2>nul
mkdir "android-build\user-app\app\src\main\res\values" 2>nul

(
echo package com.xvip.store;
echo.
echo import android.annotation.SuppressLint;
echo import android.app.Activity;
echo import android.os.Bundle;
echo import android.webkit.WebChromeClient;
echo import android.webkit.WebSettings;
echo import android.webkit.WebView;
echo import android.webkit.WebViewClient;
echo.
echo public class MainActivity extends Activity {
echo     private WebView webView;
echo     // Change to your 24/7 cloud server URL once deployed, or keep local IP
echo     private static final String APP_URL = "http://10.0.2.2:3000/user.html";
echo.
echo     @SuppressLint("SetJavaScriptEnabled")
echo     @Override
echo     protected void onCreate(Bundle savedInstanceState) {
echo         super.onCreate(savedInstanceState);
echo         webView = new WebView(this);
echo         setContentView(webView);
echo.
echo         WebSettings settings = webView.getSettings();
echo         settings.setJavaScriptEnabled(true);
echo         settings.setDomStorageEnabled(true);
echo         settings.setDatabaseEnabled(true);
echo         settings.setAllowFileAccess(true);
echo         settings.setCacheMode(WebSettings.LOAD_DEFAULT);
echo.
echo         webView.setWebViewClient(new WebViewClient());
echo         webView.setWebChromeClient(new WebChromeClient());
echo         webView.loadUrl(APP_URL);
echo     }
echo.
echo     @Override
echo     public void onBackPressed() {
echo         if (webView.canGoBack()) {
echo             webView.goBack();
echo         } else {
echo             super.onBackPressed();
echo         }
echo     }
echo }
) > "android-build\user-app\app\src\main\java\com\xvip\store\MainActivity.java"

(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<manifest xmlns:android="http://schemas.android.com/apk/res/android"
echo     package="com.xvip.store"^>
echo     ^<uses-permission android:name="android.permission.INTERNET" /^>
echo     ^<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" /^>
echo     ^<application
echo         android:label="XER'S VIP STORE"
echo         android:usesCleartextTraffic="true"
echo         android:theme="@android:style/Theme.NoTitleBar.Fullscreen"^>
echo         ^<activity android:name=".MainActivity"
echo             android:exported="true"
echo             android:configChanges="orientation|screenSize|keyboardHidden"^>
echo             ^<intent-filter^>
echo                 ^<action android:name="android.intent.action.MAIN" /^>
echo                 ^<category android:name="android.intent.category.LAUNCHER" /^>
echo             ^</intent-filter^>
echo         ^</activity^>
echo     ^</application^>
echo ^</manifest^>
) > "android-build\user-app\app\src\main\AndroidManifest.xml"

:: Generate Admin App Android Project
mkdir "android-build\admin-app\app\src\main\java\com\xvip\admin" 2>nul
mkdir "android-build\admin-app\app\src\main\res\values" 2>nul

(
echo package com.xvip.admin;
echo.
echo import android.annotation.SuppressLint;
echo import android.app.Activity;
echo import android.os.Bundle;
echo import android.webkit.WebChromeClient;
echo import android.webkit.WebSettings;
echo import android.webkit.WebView;
echo import android.webkit.WebViewClient;
echo.
echo public class MainActivity extends Activity {
echo     private WebView webView;
echo     private static final String APP_URL = "http://10.0.2.2:3000/admin.html";
echo.
echo     @SuppressLint("SetJavaScriptEnabled")
echo     @Override
echo     protected void onCreate(Bundle savedInstanceState) {
echo         super.onCreate(savedInstanceState);
echo         webView = new WebView(this);
echo         setContentView(webView);
echo.
echo         WebSettings settings = webView.getSettings();
echo         settings.setJavaScriptEnabled(true);
echo         settings.setDomStorageEnabled(true);
echo         settings.setDatabaseEnabled(true);
echo         settings.setAllowFileAccess(true);
echo         settings.setCacheMode(WebSettings.LOAD_DEFAULT);
echo.
echo         webView.setWebViewClient(new WebViewClient());
echo         webView.setWebChromeClient(new WebChromeClient());
echo         webView.loadUrl(APP_URL);
echo     }
echo.
echo     @Override
echo     public void onBackPressed() {
echo         if (webView.canGoBack()) {
echo             webView.goBack();
echo         } else {
echo             super.onBackPressed();
echo         }
echo     }
echo }
) > "android-build\admin-app\app\src\main\java\com\xvip\admin\MainActivity.java"

(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<manifest xmlns:android="http://schemas.android.com/apk/res/android"
echo     package="com.xvip.admin"^>
echo     ^<uses-permission android:name="android.permission.INTERNET" /^>
echo     ^<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" /^>
echo     ^<application
echo         android:label="XER'S VIP ADMIN"
echo         android:usesCleartextTraffic="true"
echo         android:theme="@android:style/Theme.NoTitleBar.Fullscreen"^>
echo         ^<activity android:name=".MainActivity"
echo             android:exported="true"
echo             android:configChanges="orientation|screenSize|keyboardHidden"^>
echo             ^<intent-filter^>
echo                 ^<action android:name="android.intent.action.MAIN" /^>
echo                 ^<category android:name="android.intent.category.LAUNCHER" /^>
echo             ^</intent-filter^>
echo         ^</activity^>
echo     ^</application^>
echo ^</manifest^>
) > "android-build\admin-app\app\src\main\AndroidManifest.xml"

echo [+] Generated Android projects:
echo     - android-build\user-app (For Customer Store APK)
echo     - android-build\admin-app (For Admin Management Console APK)
echo.
echo You can open either folder in Android Studio and click Build -> Build Bundle(s) / APK(s) -> Build APK(s)!
goto FINISH

:METHOD_PWA
echo.
echo ==============================================================
echo   INSTANT 1-TAP ANDROID APP INSTALLATION (PWA METHOD)
echo ==============================================================
echo.
echo You already have PWA enabled with offline service worker!
echo  1. Host the website (or connect your phone to your PC's Wi-Fi IP).
echo  2. Open Chrome, Edge, or Brave on your Android phone.
echo  3. Navigate to:
echo     - Customer Store: http://YOUR_IP:3000/user.html
echo     - Admin Console : http://YOUR_IP:3000/admin.html
echo  4. Tap the three dots (Menu) at top right.
echo  5. Tap 'Install app' or 'Add to Home screen'.
echo.
echo A real native app icon will be installed directly on your Android phone!
echo It will launch in full-screen standalone mode with no browser URL bar!
echo ==============================================================
goto FINISH

:FINISH
echo.
echo ==============================================================
echo                      ANDROID BUILD READY!
echo ==============================================================
echo.
pause
