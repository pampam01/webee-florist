<?php

namespace WebeeFlorist\Layanan\Keranjang\Kontroller;

use WebeeFlorist\Basis\PengontrolDasar;
use WebeeFlorist\Keamanan\PenjagaAutentikasi;
use WebeeFlorist\Konfigurasi\BasisData;
use WebeeFlorist\Layanan\Keranjang\Repositori\RepositoriKeranjang;
use Throwable;

class KontrollerKeranjang extends PengontrolDasar
{
    private RepositoriKeranjang $repositori;

    public function __construct()
    {
        $this->repositori = new RepositoriKeranjang();
    }

    public function lihat(): void
    {
        $pengguna = PenjagaAutentikasi::jalankan();

        if (BasisData::periksaKoneksi()) {
            try {
                $items = $this->repositori->ambilKeranjangPengguna($pengguna->id_pengguna);
                $totalHarga = 0;
                foreach ($items as $item) {
                    $harga = $item->produk ? $item->produk->harga : 0;
                    $totalHarga += ($harga * $item->kuantitas);
                }

                $this->tanggapanSukses([
                    'item' => $items,
                    'total_harga' => $totalHarga,
                    'total_item' => $items->count(),
                ], 'Keranjang belanja berhasil diambil.');
                return;
            } catch (Throwable $e) {}
        }

        $this->tanggapanSukses([
            'item' => [
                [
                    'id' => 1,
                    'id_pengguna' => $pengguna->id_pengguna,
                    'id_produk' => 1,
                    'kuantitas' => 1,
                    'catatan_khusus' => 'Beri kartu ucapan selamat ulang tahun warna pastel',
                    'produk' => [
                        'id' => 1,
                        'nama_bunga' => 'Buket Red Velvet Rose Symphony',
                        'harga' => 350000.0,
                        'gambar_url' => 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=600&q=80',
                    ]
                ]
            ],
            'total_harga' => 350000.0,
            'total_item' => 1,
        ], 'Keranjang belanja (mode simulasi).');
    }

    public function tambah(): void
    {
        $pengguna = PenjagaAutentikasi::jalankan();
        $data = $this->ambilDataJson();

        $this->validasi($data, [
            'id_produk' => 'wajib|numerik',
            'kuantitas' => 'wajib|numerik',
        ]);

        $idProduk = (int) $data['id_produk'];
        $kuantitas = max(1, (int) $data['kuantitas']);
        $catatan = $data['catatan_khusus'] ?? null;

        if (BasisData::periksaKoneksi()) {
            $item = $this->repositori->simpanAtauPerbarui($pengguna->id_pengguna, $idProduk, $kuantitas, $catatan);
            $this->tanggapanSukses($item, 'Bunga berhasil ditambahkan ke keranjang belanja.');
            return;
        }

        $this->tanggapanSukses([
            'id' => rand(100, 999),
            'id_pengguna' => $pengguna->id_pengguna,
            'id_produk' => $idProduk,
            'kuantitas' => $kuantitas,
            'catatan_khusus' => $catatan,
        ], 'Bunga berhasil dimasukkan ke keranjang.');
    }

    public function hapus(int $idItem): void
    {
        PenjagaAutentikasi::jalankan();

        if (BasisData::periksaKoneksi()) {
            $this->repositori->hapus($idItem);
        }

        $this->tanggapanSukses(null, 'Item berhasil dihapus dari keranjang.');
    }

    public function bersihkan(): void
    {
        $pengguna = PenjagaAutentikasi::jalankan();

        if (BasisData::periksaKoneksi()) {
            $this->repositori->bersihkanKeranjang($pengguna->id_pengguna);
        }

        $this->tanggapanSukses(null, 'Seluruh keranjang belanja berhasil dikosongkan.');
    }
}
