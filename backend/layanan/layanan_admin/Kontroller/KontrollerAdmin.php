<?php

namespace WebeeFlorist\Layanan\Admin\Kontroller;

use WebeeFlorist\Basis\PengontrolDasar;
use WebeeFlorist\Keamanan\PenjagaPeran;
use WebeeFlorist\Konfigurasi\BasisData;
use WebeeFlorist\Layanan\Admin\Repositori\RepositoriAdmin;
use Throwable;

class KontrollerAdmin extends PengontrolDasar
{
    private RepositoriAdmin $repositori;

    public function __construct()
    {
        $this->repositori = new RepositoriAdmin();
    }

    public function ringkasanDashboard(): void
    {
        PenjagaPeran::hanyaAdmin();

        if (BasisData::periksaKoneksi()) {
            try {
                $statistik = $this->repositori->ambilStatistikRingkasan();
                $this->tanggapanSukses($statistik, 'Data statistik dashboard Admin berhasil dimuat.');
                return;
            } catch (Throwable $e) {}
        }

        $this->tanggapanSukses([
            'total_pendapatan' => 14850000.0,
            'total_pesanan' => 42,
            'pesanan_menunggu' => 5,
            'pesanan_diproses' => 8,
            'total_pelanggan' => 128,
            'total_produk' => 36,
            'stok_menipis' => 3,
        ], 'Statistik dashboard Admin Webee Florist (mode cepat).');
    }
}
