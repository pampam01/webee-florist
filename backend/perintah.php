<?php

declare(strict_types=1);

require_once __DIR__ . '/vendor/autoload.php';

use WebeeFlorist\Konfigurasi\Aplikasi;
use WebeeFlorist\Konfigurasi\BasisData;
use WebeeFlorist\BasisData\Migrasi\SkemaBasisData;
use WebeeFlorist\BasisData\Pembenih\BenihAwal;

Aplikasi::inisialisasi();

$perintah = $argv[1] ?? 'bantuan';

echo "\n=======================================================\n";
echo "  🌸 WEBEE FLORIST MIKROSERVIS CLI TOOLKIT 🌸\n";
echo "=======================================================\n";

switch ($perintah) {
    case 'migrasi':
        echo "Menjalankan migrasi basis data...\n";
        try {
            SkemaBasisData::jalankan();
        } catch (\Throwable $e) {
            echo "❌ Gagal menjalankan migrasi: " . $e->getMessage() . "\n";
            echo "Tips: Pastikan server MySQL Anda aktif di konfigurasi .env\n";
        }
        break;

    case 'benih':
        echo "Menjalankan pembenihan data awal...\n";
        try {
            BenihAwal::jalankan();
        } catch (\Throwable $e) {
            echo "❌ Gagal memasukkan data benih: " . $e->getMessage() . "\n";
        }
        break;

    case 'status':
        echo "Status Lingkungan:\n";
        echo " - Nama Aplikasi : " . Aplikasi::ambil('NAMA_APLIKASI') . "\n";
        echo " - Lingkungan    : " . Aplikasi::ambil('LINGKUNGAN') . "\n";
        echo " - Debug Mode    : " . (Aplikasi::apakahDebug() ? 'Aktif' : 'Non-aktif') . "\n";
        echo " - Driver DB     : " . Aplikasi::ambil('DB_KONEKSI') . "\n";
        echo " - Host DB       : " . Aplikasi::ambil('DB_HOST') . ":" . Aplikasi::ambil('DB_PORT') . "\n";
        echo " - Basis Data    : " . Aplikasi::ambil('DB_BASISDATA') . "\n";
        echo " - Status Koneksi: " . (BasisData::periksaKoneksi() ? '✅ Terhubung ke MySQL' : '⚠️ Belum Terhubung (Silakan nyalakan MySQL)') . "\n";
        break;

    case 'rute':
        echo "Daftar Rute Utama Mikroservis Webee Florist:\n";
        $daftar = [
            'GET    /' => 'Halaman Selamat Datang & Informasi Sistem',
            'GET    /api/v1/kesehatan' => 'Pemeriksaan Kesehatan Server (Health Check)',
            'POST   /api/v1/autentikasi/masuk' => 'Masuk Akun (Admin & Pelanggan)',
            'POST   /api/v1/autentikasi/daftar' => 'Pendaftaran Akun Pelanggan Baru',
            'GET    /api/v1/autentikasi/profil' => 'Melihat Profil Sesi Aktif',
            'GET    /api/v1/katalog/kategori' => 'Daftar Kategori Bunga',
            'GET    /api/v1/katalog/produk' => 'Katalog Bunga (Filter Kategori & Pencarian)',
            'GET    /api/v1/katalog/produk/{id}' => 'Detail Lengkap Buket Bunga',
            'POST   /api/v1/katalog/produk' => 'Tambah Produk Bunga (Khusus Admin)',
            'GET    /api/v1/keranjang' => 'Melihat Isi Keranjang Belanja',
            'POST   /api/v1/keranjang' => 'Tambah Bunga ke Keranjang',
            'DELETE /api/v1/keranjang/{id}' => 'Hapus Item dari Keranjang',
            'DELETE /api/v1/keranjang/bersihkan' => 'Kosongkan Keranjang Belanja',
            'POST   /api/v1/pesanan' => 'Checkout / Buat Pesanan Baru',
            'GET    /api/v1/pesanan/riwayat' => 'Riwayat Pesanan Pelanggan',
            'GET    /api/v1/pesanan/{id}' => 'Detail Lengkap Pesanan',
            'PATCH  /api/v1/pesanan/{id}/status' => 'Ubah Status Pesanan (Khusus Admin)',
            'GET    /api/v1/pembayaran/instruksi' => 'Daftar Rekening & QRIS Toko',
            'POST   /api/v1/pembayaran/konfirmasi' => 'Kirim Bukti / Konfirmasi Bayar',
            'PATCH  /api/v1/pembayaran/{id}/verifikasi' => 'Verifikasi Pembayaran (Khusus Admin)',
            'GET    /api/v1/admin/dashboard' => 'Ringkasan Statistik Penjualan (Khusus Admin)',
        ];
        foreach ($daftar as $rute => $deskripsi) {
            printf("  %-45s => %s\n", $rute, $deskripsi);
        }
        break;

    default:
        echo "Perintah yang tersedia:\n";
        echo "  php perintah.php status    - Cek status sistem & basis data\n";
        echo "  php perintah.php migrasi   - Eksekusi migrasi skema tabel\n";
        echo "  php perintah.php benih     - Masukkan data awal (admin & katalog)\n";
        echo "  php perintah.php rute      - Tampilkan seluruh endpoint API\n";
        break;
}
echo "\n";
