@echo off
chcp 65001 > nul
echo ========================================================
echo   🌸 MEMULAI SERVER BACKEND MIKROSERVIS WEBEE FLORIST 🌸
echo ========================================================
echo Host   : 0.0.0.0
echo Port   : 8000
echo Gateway: gerbang_api/index.php
echo.
echo Akses lokal: http://127.0.0.1:8000
echo Akses jaringan / emulator: http://0.0.0.0:8000
echo.
echo Tekan CTRL+C untuk menghentikan server.
echo ========================================================
echo.

php -S 0.0.0.0:8000 gerbang_api/index.php
