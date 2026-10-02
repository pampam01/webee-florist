@echo off
chcp 65001 > nul
echo ========================================================
echo   📱 MENJALANKAN APLIKASI FRONTEND FLUTTER WEBEE FLORIST 📱
echo ========================================================
cd /d "%~dp0"
flutter run -d web-server --web-port=5000
