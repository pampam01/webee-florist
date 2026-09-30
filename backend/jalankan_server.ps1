Write-Host "========================================================" -ForegroundColor Magenta
Write-Host "  🌸 MEMULAI SERVER BACKEND MIKROSERVIS WEBEE FLORIST 🌸" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Magenta
Write-Host "Host   : 0.0.0.0"
Write-Host "Port   : 8000"
Write-Host "Gateway: gerbang_api/index.php"
Write-Host ""
Write-Host "Akses lokal            : http://127.0.0.1:8000" -ForegroundColor Cyan
Write-Host "Akses LAN / Emulator   : http://0.0.0.0:8000" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tekan CTRL+C untuk menghentikan server." -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Magenta
Write-Host ""

php -S 0.0.0.0:8000 gerbang_api/index.php
