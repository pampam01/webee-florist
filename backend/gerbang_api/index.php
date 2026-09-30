<?php

declare(strict_types=1);

require_once __DIR__ . '/../vendor/autoload.php';
require_once __DIR__ . '/PenjagaKeamanan.php';

use Bramus\Router\Router;
use WebeeFlorist\GerbangApi\PenjagaKeamanan;
use WebeeFlorist\Konfigurasi\Aplikasi;
use WebeeFlorist\Konfigurasi\BasisData;
use WebeeFlorist\Utilitas\TanggapanJson;
use WebeeFlorist\Layanan\Autentikasi\Rute\RuteAutentikasi;
use WebeeFlorist\Layanan\Katalog\Rute\RuteKatalog;
use WebeeFlorist\Layanan\Keranjang\Rute\RuteKeranjang;
use WebeeFlorist\Layanan\Pesanan\Rute\RutePesanan;
use WebeeFlorist\Layanan\Pembayaran\Rute\RutePembayaran;
use WebeeFlorist\Layanan\Admin\Rute\RuteAdmin;

TanggapanJson::catatWaktuMulai();
PenjagaKeamanan::terapkan();

Aplikasi::inisialisasi();
BasisData::inisialisasi();

$router = new Router();
$router->setBasePath('/');

$router->get('/', function () {
    TanggapanJson::sukses([
        'nama_aplikasi' => 'Webee Florist Mikroservis API',
        'status_server' => 'Aktif Berjalan',
        'arsitektur' => 'Mikroservis PHP Native + Standalone Eloquent ORM',
        'koneksi_basisdata' => BasisData::periksaKoneksi() ? 'Terhubung (MySQL)' : 'Mode Cepat / Siap Dihubungkan',
        'tingkat_akses' => ['admin', 'pelanggan'],
        'dokumentasi_rute' => [
            'autentikasi' => '/api/v1/autentikasi (masuk, daftar, profil)',
            'katalog' => '/api/v1/katalog (kategori, produk, detail)',
            'keranjang' => '/api/v1/keranjang (lihat, tambah, hapus, bersihkan)',
            'pesanan' => '/api/v1/pesanan (buat, riwayat, detail, status)',
            'pembayaran' => '/api/v1/pembayaran (instruksi, konfirmasi, verifikasi)',
            'admin' => '/api/v1/admin (dashboard)',
        ]
    ], 'Selamat Datang di Gerbang API Webee Florist');
});

$router->get('/api/v1/kesehatan', function () {
    TanggapanJson::sukses([
        'status' => 'sehat',
        'waktu_server' => date('Y-m-d H:i:s'),
        'memori_terpakai_mb' => round(memory_get_usage(true) / 1024 / 1024, 2),
        'basisdata_aktif' => BasisData::periksaKoneksi(),
    ], 'Layanan API Mikroservis Beroperasi Normal');
});

RuteAutentikasi::daftarkan($router);
RuteKatalog::daftarkan($router);
RuteKeranjang::daftarkan($router);
RutePesanan::daftarkan($router);
RutePembayaran::daftarkan($router);
RuteAdmin::daftarkan($router);

$router->set404(function () {
    TanggapanJson::tidakDitemukan('Rute API yang Anda tuju tidak ditemukan di Gerbang Mikroservis Webee Florist.');
});

try {
    $router->run();
} catch (\Throwable $e) {
    TanggapanJson::kesalahanServer('Terjadi kesalahan tak terduga pada server.', Aplikasi::apakahDebug() ? [
        'pesan' => $e->getMessage(),
        'file' => $e->getFile(),
        'baris' => $e->getLine(),
    ] : null);
}
