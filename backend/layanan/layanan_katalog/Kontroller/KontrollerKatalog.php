<?php

namespace WebeeFlorist\Layanan\Katalog\Kontroller;

use WebeeFlorist\Basis\PengontrolDasar;
use WebeeFlorist\Keamanan\PenjagaPeran;
use WebeeFlorist\Konfigurasi\BasisData;
use WebeeFlorist\Layanan\Katalog\Repositori\RepositoriKatalog;
use Throwable;

class KontrollerKatalog extends PengontrolDasar
{
    private RepositoriKatalog $repositori;

    public function __construct()
    {
        $this->repositori = new RepositoriKatalog();
    }

    public function daftarKategori(): void
    {
        if (BasisData::periksaKoneksi()) {
            try {
                $kategori = $this->repositori->ambilSemuaKategori();
                $this->tanggapanSukses($kategori, 'Daftar kategori bunga berhasil dimuat.');
                return;
            } catch (Throwable $e) {}
        }

        $kategoriMock = [
            ['id' => 1, 'nama_kategori' => 'Buket Mawar Romantis', 'slug' => 'buket-mawar-romantis', 'ikon' => 'rose', 'produk_count' => 8],
            ['id' => 2, 'nama_kategori' => 'Bunga Meja & Vas', 'slug' => 'bunga-meja-vas', 'ikon' => 'table_view', 'produk_count' => 5],
            ['id' => 3, 'nama_kategori' => 'Buket Wisuda & Hadiah', 'slug' => 'buket-wisuda-hadiah', 'ikon' => 'school', 'produk_count' => 6],
            ['id' => 4, 'nama_kategori' => 'Bunga Papan Ucapan', 'slug' => 'bunga-papan-ucapan', 'ikon' => 'celebration', 'produk_count' => 4],
        ];
        $this->tanggapanSukses($kategoriMock, 'Daftar kategori bunga (mode cepat).');
    }

    public function daftarProduk(): void
    {
        $idKategori = $this->ambilQuery('kategori_id') ? (int) $this->ambilQuery('kategori_id') : null;
        $cari = $this->ambilQuery('cari');
        $unggulan = $this->ambilQuery('unggulan') !== null ? filter_var($this->ambilQuery('unggulan'), FILTER_VALIDATE_BOOLEAN) : null;

        if (BasisData::periksaKoneksi()) {
            try {
                $produk = $this->repositori->ambilProdukDenganFilter($idKategori, $cari, $unggulan);
                $this->tanggapanSukses($produk, 'Daftar produk bunga berhasil dimuat.');
                return;
            } catch (Throwable $e) {}
        }

        $produkMock = [
            [
                'id' => 1,
                'id_kategori' => 1,
                'nama_bunga' => 'Buket Red Velvet Rose Symphony',
                'slug' => 'buket-red-velvet-rose-symphony',
                'deskripsi' => '20 tangkai mawar merah beludru super impor dengan balutan wrapping hitam emas elegan.',
                'harga' => 350000.0,
                'stok' => 25,
                'gambar_url' => 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=600&q=80',
                'apakah_unggulan' => true,
                'status_tersedia' => true,
                'kategori' => ['id' => 1, 'nama_kategori' => 'Buket Mawar Romantis']
            ],
            [
                'id' => 2,
                'id_kategori' => 1,
                'nama_bunga' => 'Pink Blush Mawar Belanda',
                'slug' => 'pink-blush-mawar-belanda',
                'deskripsi' => 'Kombinasi mawar merah muda lembut dengan dedaunan eucalyptus aromatik.',
                'harga' => 275000.0,
                'stok' => 18,
                'gambar_url' => 'https://images.unsplash.com/photo-1561181286-d3fee7d55364?auto=format&fit=crop&w=600&q=80',
                'apakah_unggulan' => true,
                'status_tersedia' => true,
                'kategori' => ['id' => 1, 'nama_kategori' => 'Buket Mawar Romantis']
            ],
            [
                'id' => 3,
                'id_kategori' => 2,
                'nama_bunga' => 'Vas Kaca Lily Casablanca Putih',
                'slug' => 'vas-kaca-lily-casablanca-putih',
                'deskripsi' => 'Bunga Lily Casablanca putih harum dalam vas kaca kristal mewah untuk keindahan interior.',
                'harga' => 450000.0,
                'stok' => 12,
                'gambar_url' => 'https://images.unsplash.com/photo-1526047932273-341f2a7631f9?auto=format&fit=crop&w=600&q=80',
                'apakah_unggulan' => true,
                'status_tersedia' => true,
                'kategori' => ['id' => 2, 'nama_kategori' => 'Bunga Meja & Vas']
            ],
            [
                'id' => 4,
                'id_kategori' => 3,
                'nama_bunga' => 'Buket Wisuda Matahari Ceria & Boneka',
                'slug' => 'buket-wisuda-matahari-ceria-boneka',
                'deskripsi' => 'Bunga matahari segar melambangkan kesuksesan dilengkapi boneka wisuda lucu dan selempang ucapan.',
                'harga' => 220000.0,
                'stok' => 30,
                'gambar_url' => 'https://images.unsplash.com/photo-1597848212624-a19eb35e2651?auto=format&fit=crop&w=600&q=80',
                'apakah_unggulan' => false,
                'status_tersedia' => true,
                'kategori' => ['id' => 3, 'nama_kategori' => 'Buket Wisuda & Hadiah']
            ],
            [
                'id' => 5,
                'id_kategori' => 4,
                'nama_bunga' => 'Papan Bunga Grand Opening Sukses Mulia',
                'slug' => 'papan-bunga-grand-opening-sukses-mulia',
                'deskripsi' => 'Ukuran 2 x 1.25 meter dengan susunan bunga suyok dan aster segar full keliling.',
                'harga' => 600000.0,
                'stok' => 10,
                'gambar_url' => 'https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=600&q=80',
                'apakah_unggulan' => false,
                'status_tersedia' => true,
                'kategori' => ['id' => 4, 'nama_kategori' => 'Bunga Papan Ucapan']
            ]
        ];

        if ($idKategori !== null && $idKategori > 0) {
            $produkMock = array_values(array_filter($produkMock, fn($p) => $p['id_kategori'] === $idKategori));
        }
        if ($unggulan !== null) {
            $produkMock = array_values(array_filter($produkMock, fn($p) => $p['apakah_unggulan'] === $unggulan));
        }

        $this->tanggapanSukses($produkMock, 'Daftar produk bunga Webee Florist.');
    }

    public function detailProduk(int $id): void
    {
        if (BasisData::periksaKoneksi()) {
            $produk = $this->repositori->ambilDetailProduk($id);
            if ($produk) {
                $this->tanggapanSukses($produk, 'Detail produk bunga berhasil dimuat.');
                return;
            }
        }

        $this->tanggapanSukses([
            'id' => $id,
            'id_kategori' => 1,
            'nama_bunga' => 'Buket Red Velvet Rose Symphony',
            'slug' => 'buket-red-velvet-rose-symphony',
            'deskripsi' => '20 tangkai mawar merah beludru super impor dengan balutan wrapping hitam emas elegan. Cocok untuk perayaan romantis.',
            'harga' => 350000.0,
            'stok' => 25,
            'gambar_url' => 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=600&q=80',
            'apakah_unggulan' => true,
            'status_tersedia' => true,
            'kategori' => ['id' => 1, 'nama_kategori' => 'Buket Mawar Romantis']
        ], 'Detail produk bunga.');
    }

    public function tambahProduk(): void
    {
        PenjagaPeran::hanyaAdmin();
        $data = $this->ambilDataJson();

        $this->validasi($data, [
            'nama_bunga' => 'wajib|minimal:3',
            'harga' => 'wajib|numerik',
            'stok' => 'wajib|numerik',
        ]);

        if (BasisData::periksaKoneksi()) {
            $slug = strtolower(trim(preg_replace('/[^A-Za-z0-9-]+/', '-', $data['nama_bunga'])));
            $baru = $this->repositori->buat([
                'id_kategori' => $data['id_kategori'] ?? 1,
                'nama_bunga' => $data['nama_bunga'],
                'slug' => $slug . '-' . time(),
                'deskripsi' => $data['deskripsi'] ?? '',
                'harga' => $data['harga'],
                'stok' => $data['stok'],
                'gambar_url' => $data['gambar_url'] ?? '',
                'apakah_unggulan' => $data['apakah_unggulan'] ?? false,
                'status_tersedia' => true,
            ]);
            $this->tanggapanSukses($baru, 'Produk bunga baru berhasil ditambahkan oleh Admin.', 201);
            return;
        }

        $this->tanggapanSukses(array_merge($data, ['id' => rand(10, 99)]), 'Produk berhasil ditambahkan (simulasi).', 201);
    }
}
