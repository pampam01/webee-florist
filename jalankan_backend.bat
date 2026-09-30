@echo off
chcp 65001 > nul
echo ========================================================
echo   🌸 MEMULAI SERVER BACKEND MIKROSERVIS WEBEE FLORIST 🌸
echo ========================================================
cd /d "%~dp0backend"
call jalankan_server.bat
