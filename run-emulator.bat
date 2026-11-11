@echo off
title Airin App - Android Emulator Launcher
echo ========================================================
echo   Airin App - Menjalankan Emulator Tanpa Android Studio
echo ========================================================
echo.

set "PATH=D:\Setiady's-Workspace\MobileDev\flutter\bin;C:\Program Files\Eclipse Adoptium\jdk-17.0.16.8-hotspot\bin;%LOCALAPPDATA%\Android\Sdk\platform-tools;%LOCALAPPDATA%\Android\Sdk\emulator;%PATH%"
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.16.8-hotspot"
set "ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk"

echo [1/2] Menyalakan emulator Medium_Phone_API_36.0...
start "" "%LOCALAPPDATA%\Android\Sdk\emulator\emulator.exe" -avd Medium_Phone_API_36.0

echo Menunggu emulator siap...
timeout /t 5 /nobreak >nul

echo [2/2] Menjalankan flutter run...
flutter run

pause

