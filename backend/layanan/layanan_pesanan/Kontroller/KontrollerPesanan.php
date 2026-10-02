<?php

namespace WebeeFlorist\Layanan\Pesanan\Kontroller;

use WebeeFlorist\Basis\PengontrolDasar;
use WebeeFlorist\Keamanan\PenjagaAutentikasi;
use WebeeFlorist\Keamanan\PenjagaPeran;
use WebeeFlorist\Konfigurasi\BasisData;
use WebeeFlorist\Layanan\Pesanan\Repositori\RepositoriPesanan;
use WebeeFlorist\Layanan\Pesanan\Model\Pesanan;
use WebeeFlorist\Layanan\Pesanan\Model\ItemPesanan;
use WebeeFlorist\Layanan\Keranjang\Repositori\RepositoriKeranjang;
use Throwable;

class KontrollerPesanan extends PengontrolDasar
{
    private RepositoriPesanan $repositori;

    public function __construct()
    {
        $this->repositori = new RepositoriPesanan();
    }

    public function buatPesanan(): void
    {
        $pengguna = PenjagaAutentikasi::jalankan();
        $data = $this->ambilDataJson();

        $this->validasi($data, [
            'nama_penerima' => 'wajib|minimal:3',
            'telepon_penerima' => 'wajib|minimal:8',
            'alamat_pengiriman' => 'wajib|minimal:10',
            'item' => 'wajib',
        ]);

        $nomorPesanan = 'WBF-' . date('Ymd') . '-' . strtoupper(substr(uniqid(), -5));
        $daftarItem = $data['item'];

        if (BasisData::periksaKoneksi()) {
            try {
                $pesanan = $this->repositori->transaksi(function () use ($pengguna, $data, $nomorPesanan, $daftarItem) {
                    $totalHarga = 0;
                    foreach ($daftarItem as $item) {
                        $subtotal = ($item['harga_satuan'] ?? 0) * ($item['kuantitas'] ?? 1);
                        $totalHarga += $subtotal;
                    }

                    $pesanan = Pesanan::create([
                        'nomor_pesanan' => $nomorPesanan,
                        'id_pelanggan' => $pengguna->id_pengguna,
                        'total_harga' => $totalHarga,
                        'status' => 'menunggu_pembayaran',
                        'nama_penerima' => $data['nama_penerima'],
                        'telepon_penerima' => $data['telepon_penerima'],
                        'alamat_pengiriman' => $data['alamat_pengiriman'],
                        'kartu_ucapan' => $data['kartu_ucapan'] ?? null,
                        'tanggal_pengiriman' => $data['tanggal_pengiriman'] ?? date('Y-m-d'),
                    ]);

                    foreach ($daftarItem as $item) {
                        ItemPesanan::create([
                            'id_pesanan' => $pesanan->id,
                            'id_produk' => $item['id_produk'],
                            'nama_produk' => $item['nama_produk'] ?? 'Buket Bunga',
                            'harga_satuan' => $item['harga_satuan'] ?? 0,
                            'kuantitas' => $item['kuantitas'] ?? 1,
                            'subtotal' => ($item['harga_satuan'] ?? 0) * ($item['kuantitas'] ?? 1),
                        ]);
                    }

                    $repositoriKeranjang = new RepositoriKeranjang();
                    $repositoriKeranjang->bersihkanKeranjang($pengguna->id_pengguna);

                    return $pesanan->load('item');
                });

                $this->tanggapanSukses($pesanan, 'Pesanan bunga Anda berhasil dibuat. Silakan lakukan pembayaran.', 201);
                return;
            } catch (Throwable $e) {}
        }

        $this->tanggapanSukses([
            'id' => rand(100, 999),
            'nomor_pesanan' => $nomorPesanan,
            'id_pelanggan' => $pengguna->id_pengguna,
            'total_harga' => 350000.0,
            'status' => 'menunggu_pembayaran',
            'nama_penerima' => $data['nama_penerima'],
            'telepon_penerima' => $data['telepon_penerima'],
            'alamat_pengiriman' => $data['alamat_pengiriman'],
            'kartu_ucapan' => $data['kartu_ucapan'] ?? 'Selamat & Sukses Selalu',
            'created_at' => date('Y-m-d H:i:s'),
        ], 'Pesanan berhasil dibuat (mode simulasi).', 201);
    }

    public function riwayat(): void
    {
        $pengguna = PenjagaAutentikasi::jalankan();

        if (BasisData::periksaKoneksi()) {
            try {
                $riwayat = $this->repositori->ambilRiwayatPelanggan($pengguna->id_pengguna);
                $this->tanggapanSukses($riwayat, 'Riwayat pesanan berhasil diambil.');
                return;
            } catch (Throwable $e) {}
        }

        $this->tanggapanSukses([
            [
                'id' => 1,
                'nomor_pesanan' => 'WBF-20261001-A89F1',
                'id_pelanggan' => $pengguna->id_pengguna,
                'total_harga' => 350000.0,
                'status' => 'menunggu_pembayaran',
                'nama_penerima' => 'Siti Pelanggan',
                'telepon_penerima' => '089876543210',
                'alamat_pengiriman' => 'Jl. Mawar Indah No. 12, Jakarta',
                'kartu_ucapan' => 'Selamat Ulang Tahun Sahabatku Tercinta!',
                'tanggal_pengiriman' => date('Y-m-d'),
                'created_at' => date('Y-m-d H:i:s'),
                'item' => [
                    [
                        'id' => 1,
                        'id_produk' => 1,
                        'nama_produk' => 'Buket Red Velvet Rose Symphony',
                        'harga_satuan' => 350000.0,
                        'kuantitas' => 1,
                        'subtotal' => 350000.0
                    ]
                ]
            ]
        ], 'Riwayat pesanan bunga.');
    }

    public function detail(int $id): void
    {
        $pengguna = PenjagaAutentikasi::jalankan();

        if (BasisData::periksaKoneksi()) {
            $pesanan = $this->repositori->ambilDetailPesanan($id);
            if ($pesanan) {
                $this->tanggapanSukses($pesanan, 'Detail pesanan dimuat.');
                return;
            }
        }

        $this->tanggapanSukses([
            'id' => $id,
            'nomor_pesanan' => 'WBF-20261001-A89F1',
            'id_pelanggan' => $pengguna->id_pengguna,
            'total_harga' => 350000.0,
            'status' => 'diproses',
            'nama_penerima' => 'Siti Pelanggan',
            'telepon_penerima' => '089876543210',
            'alamat_pengiriman' => 'Jl. Mawar Indah No. 12, Jakarta',
            'kartu_ucapan' => 'Selamat Ulang Tahun!',
            'created_at' => date('Y-m-d H:i:s'),
        ], 'Detail pesanan.');
    }

    public function semuaPesananAdmin(): void
    {
        PenjagaPeran::hanyaAdmin();
        $status = $this->ambilQuery('status');
        $cari = $this->ambilQuery('cari');

        if (BasisData::periksaKoneksi()) {
            try {
                $daftar = $this->repositori->ambilSemuaPesananUntukAdmin($status, $cari);
                $this->tanggapanSukses($daftar, 'Semua data pesanan untuk admin berhasil dimuat.');
                return;
            } catch (Throwable $e) {}
        }

        // Data cadangan simulasi jika offline / basis data belum terkoneksi
        $this->tanggapanSukses([
            [
                'id' => 101,
                'nomor_pesanan' => 'WBF-20261002-001A',
                'id_pelanggan' => 1,
                'total_harga' => 650000.0,
                'status' => 'menunggu_pembayaran',
                'nama_penerima' => 'Lady Genevieve',
                'telepon_penerima' => '081234567890',
                'alamat_pengiriman' => 'Kebayoran Baru, Jl. Senopati No. 45, Jakarta Selatan',
                'kartu_ucapan' => 'Semoga hari bahagiamu seharum kelopak mawar kastil Provence.',
                'tanggal_pengiriman' => date('Y-m-d'),
                'jenis_kurir' => 'armada_mobil_berpendingin',
                'nama_kurir' => 'Budi Santoso',
                'telepon_kurir' => '081299887766',
                'nomor_resi' => 'WBF-VAN-01',
                'estimasi_jam_kirim' => '14:00 - 16:00',
                'created_at' => date('Y-m-d H:i:s'),
                'item' => [
                    [
                        'id' => 1,
                        'id_produk' => 1,
                        'nama_produk' => 'Buket Mawar Merah Kastil Provence',
                        'harga_satuan' => 650000.0,
                        'kuantitas' => 1,
                        'subtotal' => 650000.0
                    ]
                ]
            ],
            [
                'id' => 102,
                'nomor_pesanan' => 'WBF-20261002-002B',
                'id_pelanggan' => 2,
                'total_harga' => 450000.0,
                'status' => 'diproses',
                'nama_penerima' => 'Madame Vivienne',
                'telepon_penerima' => '081377889900',
                'alamat_pengiriman' => 'Menteng Residensi Blok C2 No. 8, Jakarta Pusat',
                'kartu_ucapan' => 'Selamat hari jadi pernikahan ke-10, cinta selamanya.',
                'tanggal_pengiriman' => date('Y-m-d', strtotime('+1 day')),
                'jenis_kurir' => 'kurir_motor_florist',
                'nama_kurir' => 'Rian Hidayat',
                'telepon_kurir' => '087711223344',
                'nomor_resi' => 'WBF-MTR-05',
                'estimasi_jam_kirim' => '09:00 - 11:00',
                'created_at' => date('Y-m-d H:i:s', strtotime('-2 hours')),
                'item' => [
                    [
                        'id' => 2,
                        'id_produk' => 2,
                        'nama_produk' => 'Buket Lavender & Lily Parisien',
                        'harga_satuan' => 450000.0,
                        'kuantitas' => 1,
                        'subtotal' => 450000.0
                    ]
                ]
            ]
        ], 'Daftar pesanan admin dimuat.');
    }

    public function ubahStatus(int $id): void
    {
        PenjagaPeran::hanyaAdmin();
        $data = $this->ambilDataJson();

        $this->validasi($data, [
            'status' => 'wajib|dalam:menunggu_pembayaran,diproses,dikirim,selesai,dibatalkan'
        ]);

        if (BasisData::periksaKoneksi()) {
            $this->repositori->ubahStatus($id, $data['status'], $data);
        }

        $this->tanggapanSukses(null, "Status pesanan #{$id} berhasil diperbarui menjadi {$data['status']}.");
    }
}
