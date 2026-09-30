<?php

namespace WebeeFlorist\Layanan\Pesanan\Repositori;

use WebeeFlorist\Basis\RepositoriDasar;
use WebeeFlorist\Layanan\Pesanan\Model\Pesanan;
use WebeeFlorist\Layanan\Pesanan\Model\ItemPesanan;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Collection;

class RepositoriPesanan extends RepositoriDasar
{
    protected function ambilModel(): Model
    {
        return new Pesanan();
    }

    public function ambilRiwayatPelanggan(int $idPelanggan): Collection
    {
        return Pesanan::with(['item', 'pembayaran'])
            ->where('id_pelanggan', $idPelanggan)
            ->orderBy('created_at', 'desc')
            ->get();
    }

    public function ambilDetailPesanan(int $idPesanan, ?int $idPelanggan = null): ?Pesanan
    {
        $kueri = Pesanan::with(['item', 'pelanggan', 'pembayaran'])->where('id', $idPesanan);
        if ($idPelanggan !== null) {
            $kueri->where('id_pelanggan', $idPelanggan);
        }
        return $kueri->first();
    }

    public function ubahStatus(int $idPesanan, string $statusBaru): bool
    {
        $pesanan = Pesanan::find($idPesanan);
        if ($pesanan) {
            $pesanan->status = $statusBaru;
            return $pesanan->save();
        }
        return false;
    }
}
