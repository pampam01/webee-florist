# PANDUAN ARSITEKTUR ENTERPRISE WEBEE FLORIST
> **Arsitektur Mikroservis Korporasi Terpadu (Modular Monorepo Microservices)**
> Dirancang untuk skalabilitas, kemudahan pemeliharaan, serta kolaborasi tim insinyur perangkat lunak (*Software Engineers*) dan agen kecerdasan buatan (*AI Agents*).

---

## 1. Ikhtisar Arsitektur Sistem

Proyek **Webee Florist** mengadopsi prinsip **Feature-First Clean Architecture** pada sisi Frontend (Flutter Web, iOS, Android, Desktop) langsung di root folder, dan **Modular Microservice dengan Standalone Eloquent ORM** pada sisi Backend (PHP Native) di folder `backend/`.

### Nilai Desain & Identitas Brand
- **Gaya Visual**: Klasik Romantis Perancis & Abad Seniman Pertengahan (*French Romantic & Medieval Artisan Atelier*).
- **Palet Warna Utama**:
  - French Chestnut Brown (`#6B4435`)
  - Warm Alabaster Parchment (`#FAF7F2`)
  - Antique Gold Accent (`#C59B27`)
  - Dusty Parisian Rose (`#C87D75`)
  - Deep Espresso Charcoal (`#2D1F1B`)
- **Tipografi**:
  - Judul / Display: *Playfair Display*
  - Body / Konten: *Plus Jakarta Sans*
- **Pendekatan UX Web**:
  - Navigasi atas elegan (*Top Navigation Bar*) menggantikan bottom bar pada layar web/desktop.
  - Bebas jelajah katalog & tambah keranjang tanpa login awal (*No-login barrier*).
  - Autentikasi hanya diminta ketika pengunjung melakukan checkout (*Cart Drawer Checkout Trigger*).

---

### Susunan Direktori Utama:
```text
webee-florist/
├── backend/                          # Backend Mikroservis PHP Native
│   ├── gerbang_api/                  # API Gateway (Router terpusat, CORS, Penjaga)
│   │   ├── index.php                 # Titik Masuk API Gateway
│   │   └── PenjagaKeamanan.php       # Middleware Keamanan & CORS Guard
│   ├── layanan_bersama/              # Shared Kernel (Basis Data ORM, Keamanan JWT, Utilitas)
│   │   ├── Konfigurasi/              # Aplikasi.php & BasisData.php (Eloquent Capsule)
│   │   ├── Utilitas/                 # TanggapanJson.php & ValidasiPermintaan.php
│   │   ├── Keamanan/                 # ManajerToken.php, PenjagaAutentikasi, PenjagaPeran
│   │   ├── Basis/                    # ModelDasar, RepositoriDasar, PengontrolDasar
│   │   └── BasisData/                # Migrasi Skema ORM & Pembenih Data Awal
│   ├── layanan/                      # Direktori Layanan Bisnis Mikro Independen
│   │   ├── layanan_autentikasi/      # Manajemen Akun, Login, Register, Profil
│   │   ├── layanan_katalog/          # Manajemen Buket Bunga, Kategori, Stok
│   │   ├── layanan_keranjang/        # Keranjang Belanja Pelanggan
│   │   ├── layanan_pesanan/          # Checkout, Nomor Pesanan, Lacak Status
│   │   ├── layanan_pembayaran/       # Simulasi Bayar, Rekening/QRIS, Verifikasi
│   │   └── layanan_admin/            # Analitik Omset, Metrik Toko Bunga
│   ├── vendor/                       # Paket Composer Terpasang
│   ├── .env                          # Variabel Lingkungan Aktif
│   ├── composer.json                 # Konfigurasi Dependensi PHP
│   ├── jalankan_server.bat           # Skrip Menjalankan Server Lokal (0.0.0.0:8000)
│   ├── jalankan_server.ps1           # Skrip PowerShell
│   └── perintah.php                  # CLI Toolkit (Migrasi, Benih, Rute, Status)
├── lib/                              # Kode Sumber Frontend Flutter (Riverpod)
│   ├── inti/                         # Core Layer (Jaringan, Konstanta, Tema, Utilitas)
│   │   ├── jaringan/                 # KlienApi Dio, Interceptors, HasilApi
│   │   ├── konstanta/                # KonstantaApi, WarnaAplikasi
│   │   ├── tema/                     # TemaAplikasi (Playfair Display + Plus Jakarta Sans)
│   │   └── utilitas/                 # FormatRupiah, PenyimpanLokal
│   ├── fitur/                        # Modul Fitur Mikro Independen (Feature-First)
│   │   ├── landing_page/             # Modul Landing Page Web Mewah (Navigasi Atas, Hero,
│   │   │                             # Koleksi, Produk Unggulan, Filosofi, Keunggulan, Ulasan,
│   │   │                             # Kaki Halaman, Laci Keranjang, Dialog Masuk Cepat)
│   │   ├── autentikasi/              # State Auth Riverpod, Login, Register, Sesi Token
│   │   ├── katalog_bunga/            # Repositori Produk/Kategori, Filter, Detail Bunga
│   │   ├── keranjang/                # State Keranjang Riverpod, Subtotal, Kuantitas
│   │   ├── pesanan/                  # Formulir Checkout, Kartu Ucapan Personal, Riwayat
│   │   ├── admin/                    # Dashboard Omset & Alur Status Pesanan
│   │   └── profil/                   # Profil Akun, Simulasi Switch Peran, Info Sistem
│   ├── navigasi/                     # Navigasi Responsif Sesuai Ukuran Layar & Peran
│   └── main.dart                     # Titik Masuk Utama Aplikasi Flutter (ProviderScope)
├── web/                              # Konfigurasi & Aset Khusus Platform Web
│   ├── index.html                    # SEO Head Meta, Schema.org JSON-LD, Semantik Crawlable
│   ├── robots.txt                    # Direktif Robot Mesin Pencari & Tautan Sitemap
│   ├── sitemap.xml                   # Peta Situs XML Terstruktur
│   └── manifest.json                 # PWA Manifest Beridentitas Webee Florist
├── assets/                           # Aset Statis Toko Bunga
│   └── logo/                         # Logo Resmi Horizontal & Persegi Webee Florist
├── test/                             # Unit & Widget Testing
├── pubspec.yaml                      # Dependensi Flutter & Konfigurasi Aset
├── jalankan_backend.bat              # Pintasan Eksekusi Backend dari Root
└── jalankan_flutter.bat              # Pintasan Eksekusi Flutter dari Root
```

---

## 2. Backend PHP Native & Standalone Eloquent ORM

### Mengapa Standalone Eloquent ORM?
Meskipun dibangun menggunakan **PHP Native murni tanpa framework monolitik yang berat**, sistem ini mengintegrasikan komponen mandiri `illuminate/database` melalui `Illuminate\Database\Capsule\Manager`. Keunggulannya:
1. **Model Relasional Terstruktur**: Relasi `hasMany`, `belongsTo`, `hasOne` antar entitas bunga, item pesanan, dan bukti bayar.
2. **Keamanan Parameterized PDO**: Seluruh parameter query terlindungi dari serangan SQL Injection.
3. **Migrasi Terstruktur Tanpa SQL Manual**: Menggunakan `Capsule::schema()` untuk membangun struktur tabel kapan saja.

### Daftar Mikroservis Backend:
| Layanan | Tanggung Jawab Utama | Model Eloquent | Hak Akses |
|---|---|---|---|
| **Layanan Autentikasi** | Register, Login JWT, Profil, Segarkan Sesi | `Pengguna` | Publik & Pengguna |
| **Layanan Katalog** | Daftar Bunga, Filter Kategori, Pencarian, Detail Produk | `ProdukBunga`, `KategoriBunga` | Publik (Baca), Admin (Tulis) |
| **Layanan Keranjang** | Tambah item ke keranjang, update kuantitas, hapus item | `ItemKeranjang` | Pelanggan & Admin |
| **Layanan Pesanan** | Buat pesanan, kartu ucapan, riwayat, update status pesanan | `Pesanan`, `ItemPesanan` | Pelanggan & Admin |
| **Layanan Pembayaran** | Ambil rekening/QRIS, kirim bukti bayar, verifikasi kasir | `Pembayaran` | Pelanggan & Admin |
| **Layanan Admin** | Ringkasan statistik, total omset, stok menipis | Agregasi ORM | Khusus Admin |

### Amplop JSON Korporasi Terpadu:
Setiap respons API diformat melalui `TanggapanJson`:
```json
{
  "sukses": true,
  "pesan": "Daftar produk bunga berhasil dimuat.",
  "data": [ ... ],
  "meta": {
    "kode_status": 200,
    "waktu_eksekusi_ms": 4.12,
    "stempel_waktu": "2026-10-01 01:00:00",
    "versi_api": "v1.0.0"
  }
}
```

---

## 3. Frontend Flutter & Arsitektur Fitur Landing Page

### Modul Landing Page (`lib/fitur/landing_page/`):
Dirancang khusus untuk menghadirkan pengalaman kelas atas (*haute couture floristry*):
1. **`BilahNavigasiAtas`**:
   - Menampilkan logo resmi horizontal Webee Florist.
   - Tombol navigasi mulus menuju seksi Koleksi, Filosofi, Keunggulan, dan Ulasan.
   - Tombol Keranjang Belanja dilengkapi badge kuantitas interaktif.
   - Tombol Masuk / Keluar yang membuka modal autentikasi tanpa memutus alur belanja.
2. **`SeksiHero`**:
   - Tipografi Playfair Display megah dengan motif lengkungan Perancis (*French Arch*).
   - Tiga pilar kepercayaan: *Bunga Impor Segar*, *Kirim Tepat Waktu*, *Kartu Ucapan Komplementer*.
3. **`SeksiKategori`**:
   - Pilihan kategori botani (Mawar Romantis, Bunga Meja Kristal, Buket Wisuda, Bunga Papan).
4. **`SeksiProdukUnggulan`**:
   - Terhubung langsung ke API MySQL via Riverpod `daftarProdukProvider`.
   - Menampilkan kartu produk eksklusif dengan tombol cepat "Tambah ke Keranjang".
5. **`SeksiCeritaFlorist`**:
   - Narasi seni botani dan filosofi atelier Webee Florist oleh Florist Utiy.
   - Menyematkan lambang resmi segel botani Webee Florist.
6. **`LaciKeranjangWeb`**:
   - Panel keranjang belanja slide-over di sisi kanan layar.
   - Menampilkan daftar buket, pengubah kuantitas, catatan khusus florist, dan rincian harga.
   - Tombol Checkout yang memicu dialog masuk cepat jika pengguna belum memiliki sesi login.

---

## 4. Optimasi SEO (Search Engine Optimization)

Halaman web telah dilengkapi dengan spesifikasi SEO lengkap di folder `web/`:
1. **Meta Tags Komprehensif**:
   - Title tag unik dengan kata kunci target florist.
   - Meta description, author, robots (`index, follow`), and canonical link.
2. **Open Graph & Twitter Cards**:
   - Preview visual otomatis saat URL dibagikan di WhatsApp, Telegram, Facebook, dan Twitter.
3. **Structured Data JSON-LD (`schema.org/Florist`)**:
   - Informasi bisnis terstruktur (nama, logo, harga, jam operasional, kontak telepon, alamat, geokoordinat, dan katalog penawaran).
4. **Semantik HTML Crawlable**:
   - Markup semantik (`<header>`, `<main>`, `<section>`, `<h1>`, `<h2>`, `<article>`, `<nav>`, `<p>`) yang dapat langsung dibaca oleh Googlebot dan Bingbot sebelum proses hidrasi engine selesai.
5. **File Dukungan Web Crawler**:
   - `web/robots.txt`: Mengatur hak akses perayap dan menunjuk ke sitemap.
   - `web/sitemap.xml`: Peta situs XML dengan prioritas dan frekuensi pembaruan.
   - `web/manifest.json`: Manifest PWA beridentitas resmi Webee Florist.

---

## 5. Cara Menjalankan & Membangun Aplikasi

### A. Menjalankan Server Backend PHP Native:
```bash
# Melalui skrip batch dari folder root
jalankan_backend.bat

# Atau manual via terminal
cd backend
php -S 0.0.0.0:8000 gerbang_api/index.php
```

### B. Menjalankan Frontend Flutter Web:
```bash
# Menjalankan di Chrome untuk pengujian interaktif
jalankan_flutter.bat

# Atau manual via terminal
flutter run -d chrome
```

### C. Membangun Bundle Produksi untuk Hosting Web:
```bash
flutter build web --release
```
Hasil build siap diunggah ke layanan hosting statis (seperti Firebase Hosting, Vercel, Netlify, Cloudflare Pages, atau Apache/Nginx) yang berlokasi di direktori `build/web/`.
