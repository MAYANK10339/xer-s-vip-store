@echo off
setlocal
cd /d "%~dp0"
title XER'S VIP STORE - Android APK Builder

echo ==============================================================
echo       XER'S VIP STORE - ANDROID .APK & MOBILE BUILDER
echo ==============================================================
echo.
echo [*] Live 24/7 Cloud URL: https://xers-vip-store.onrender.com
echo.

:: 1. Create Android Native WebView Projects
echo [*] Generating Android Project Files...
if not exist "dist-apk" mkdir "dist-apk"
if not exist "android-projects\user-app\src\main\java\com\xvip\store" mkdir "android-projects\user-app\src\main\java\com\xvip\store"
if not exist "android-projects\admin-app\src\main\java\com\xvip\admin" mkdir "android-projects\admin-app\src\main\java\com\xvip\admin"

:: User App Java
(
echo package com.xvip.store;
echo import android.annotation.SuppressLint;
echo import android.app.Activity;
echo import android.os.Bundle;
echo import android.webkit.WebChromeClient;
echo import android.webkit.WebSettings;
echo import android.webkit.WebView;
echo import android.webkit.WebViewClient;
echo public class MainActivity extends Activity {
echo     private WebView webView;
echo     @SuppressLint("SetJavaScriptEnabled"^)
echo     @Override
echo     protected void onCreate(Bundle savedInstanceState^) {
echo         super.onCreate(savedInstanceState^);
echo         webView = new WebView(this^);
echo         setContentView(webView^);
echo         WebSettings s = webView.getSettings(^);
echo         s.setJavaScriptEnabled(true^);
echo         s.setDomStorageEnabled(true^);
echo         s.setDatabaseEnabled(true^);
echo         s.setAllowFileAccess(true^);
echo         webView.setWebViewClient(new WebViewClient(^)^);
echo         webView.setWebChromeClient(new WebChromeClient(^)^);
echo         webView.loadUrl("https://xers-vip-store.onrender.com/user.html"^);
echo     }
echo     @Override
echo     public void onBackPressed(^) {
echo         if (webView != null ^&^& webView.canGoBack(^)^) { webView.goBack(^); }
echo         else { super.onBackPressed(^); }
echo     }
echo }
) > "android-projects\user-app\src\main\java\com\xvip\store\MainActivity.java"

:: Admin App Java
(
echo package com.xvip.admin;
echo import android.annotation.SuppressLint;
echo import android.app.Activity;
echo import android.os.Bundle;
echo import android.webkit.WebChromeClient;
echo import android.webkit.WebSettings;
echo import android.webkit.WebView;
echo import android.webkit.WebViewClient;
echo public class MainActivity extends Activity {
echo     private WebView webView;
echo     @SuppressLint("SetJavaScriptEnabled"^)
echo     @Override
echo     protected void onCreate(Bundle savedInstanceState^) {
echo         super.onCreate(savedInstanceState^);
echo         webView = new WebView(this^);
echo         setContentView(webView^);
echo         WebSettings s = webView.getSettings(^);
echo         s.setJavaScriptEnabled(true^);
echo         s.setDomStorageEnabled(true^);
echo         s.setDatabaseEnabled(true^);
echo         s.setAllowFileAccess(true^);
echo         webView.setWebViewClient(new WebViewClient(^)^);
echo         webView.setWebChromeClient(new WebChromeClient(^)^);
echo         webView.loadUrl("https://xers-vip-store.onrender.com/admin.html"^);
echo     }
echo     @Override
echo     public void onBackPressed(^) {
echo         if (webView != null ^&^& webView.canGoBack(^)^) { webView.goBack(^); }
echo         else { super.onBackPressed(^); }
echo     }
echo }
) > "android-projects\admin-app\src\main\java\com\xvip\admin\MainActivity.java"

echo [+] Generated Android project sources in android-projects\

:: 2. Check Java / Gradle
set "HAS_GRADLE=0"
where gradlew >nul 2>nul
if %errorlevel% equ 0 set "HAS_GRADLE=1"

echo.
echo ==============================================================
echo       HOW TO GET YOUR ANDROID .APK IN 1 MINUTE:
echo ==============================================================
echo.
echo  OPTION A: INSTANT ONLINE .APK GENERATOR (Fastest & 100%% Free)
echo  -------------------------------------------------------------
echo  1. Open: https://www.pwabuilder.com
echo  2. Enter your live URL: https://xers-vip-store.onrender.com
echo  3. Click 'Start' -^> Click 'Package for Stores'
echo  4. Under 'Android', click 'Generate Package' or 'Download APK'!
echo     You will get a signed APK file ready to install on any Android phone!
echo.
echo  OPTION B: INSTANT 1-TAP PWA INSTALL (Zero download required)
echo  -------------------------------------------------------------
echo  1. On your Android phone, open Chrome or Brave browser.
echo  2. Visit: https://xers-vip-store.onrender.com/user.html
echo  3. Tap the 3 dots menu at top-right -^> Tap 'Install app'
echo  4. It installs the native full-screen app directly on your phone!
echo.
echo  OPTION C: ANDROID STUDIO
echo  -------------------------------------------------------------
echo  Open 'android-projects\user-app' in Android Studio and click
echo  Build -^> Build APK(s) to compile locally!
echo ==============================================================
echo.
pause
