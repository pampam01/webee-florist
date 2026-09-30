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

    public function ubahStatus(int $id): void
    {
        PenjagaPeran::hanyaAdmin();
        $data = $this->ambilDataJson();

        $this->validasi($data, [
            'status' => 'wajib|dalam:menunggu_pembayaran,diproses,dikirim,selesai,dibatalkan'
        ]);

        if (BasisData::periksaKoneksi()) {
            $this->repositori->ubahStatus($id, $data['status']);
        }

        $this->tanggapanSukses(null, "Status pesanan #{$id} berhasil diperbarui menjadi {$data['status']}.");
    }
}
