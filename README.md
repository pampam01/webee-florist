# 🌸 Webee Florist - Toko Bunga Enterprise

Aplikasi Toko Bunga modern dengan arsitektur **Mikroservis PHP Native + Standalone Eloquent ORM** dan **Frontend Flutter Riverpod** modular.

## 📁 Struktur Proyek
- `flutter/` : Proyek Frontend Flutter (Clean Architecture, Feature-First, Riverpod)
  - `backend/` : Mikroservis Backend PHP Native
    - `gerbang_api/` : API Gateway terpusat
    - `layanan_bersama/` : Database Eloquent ORM, JWT, Middleware
    - `layanan/` : Modul mikroservis independen (Autentikasi, Katalog, Keranjang, Pesanan, Pembayaran, Admin)

## 🚀 Menjalankan Server & Aplikasi
1. **Jalankan Backend PHP (Host: 0.0.0.0:8000)**:
   ```bash
   jalankan_backend.bat
   ```
2. **Jalankan Frontend Flutter**:
   ```bash
   jalankan_flutter.bat
   ```
3. **Dokumentasi Lengkap**:
   Baca [PANDUAN_ARSITEKTUR.md](file:///d:/usaha/webee-florist/PANDUAN_ARSITEKTUR.md) untuk panduan mendalam arsitektur bagi engineer dan AI agent.
