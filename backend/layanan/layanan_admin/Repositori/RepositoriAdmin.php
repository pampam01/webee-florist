<?php

namespace WebeeFlorist\Layanan\Admin\Repositori;

use WebeeFlorist\Layanan\Pesanan\Model\Pesanan;
use WebeeFlorist\Layanan\Katalog\Model\ProdukBunga;
use WebeeFlorist\Layanan\Autentikasi\Model\Pengguna;

class RepositoriAdmin
{
    public function ambilStatistikRingkasan(): array
    {
        $totalPendapatan = (float) Pesanan::whereIn('status', ['diproses', 'dikirim', 'selesai'])->sum('total_harga');
        $totalPesanan = Pesanan::count();
        $pesananMenunggu = Pesanan::where('status', 'menunggu_pembayaran')->count();
        $pesananDiproses = Pesanan::where('status', 'diproses')->count();
        $totalPelanggan = Pengguna::where('peran', 'pelanggan')->count();
        $totalProduk = ProdukBunga::count();
        $stokMenipis = ProdukBunga::where('stok', '<=', 5)->count();

        return [
            'total_pendapatan' => $totalPendapatan,
            'total_pesanan' => $totalPesanan,
            'pesanan_menunggu' => $pesananMenunggu,
            'pesanan_diproses' => $pesananDiproses,
            'total_pelanggan' => $totalPelanggan,
            'total_produk' => $totalProduk,
            'stok_menipis' => $stokMenipis,
        ];
    }
}
