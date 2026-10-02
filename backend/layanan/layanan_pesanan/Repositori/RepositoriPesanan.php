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

    public function ambilSemuaPesananUntukAdmin(?string $status = null, ?string $cari = null): Collection
    {
        $kueri = Pesanan::with(['item', 'pelanggan', 'pembayaran'])->orderBy('created_at', 'desc');

        if ($status !== null && $status !== '' && $status !== 'semua') {
            $kueri->where('status', $status);
        }

        if ($cari !== null && trim($cari) !== '') {
            $kataKunci = '%' . trim($cari) . '%';
            $kueri->where(function ($q) use ($kataKunci) {
                $q->where('nomor_pesanan', 'LIKE', $kataKunci)
                  ->orWhere('nama_penerima', 'LIKE', $kataKunci)
                  ->orWhere('telepon_penerima', 'LIKE', $kataKunci);
            });
        }

        return $kueri->get();
    }

    public function ubahStatus(int $idPesanan, string $statusBaru, array $dataLogistik = []): bool
    {
        $pesanan = Pesanan::find($idPesanan);
        if ($pesanan) {
            $pesanan->status = $statusBaru;
            if (!empty($dataLogistik['jenis_kurir'])) {
                $pesanan->jenis_kurir = $dataLogistik['jenis_kurir'];
            }
            if (!empty($dataLogistik['nama_kurir'])) {
                $pesanan->nama_kurir = $dataLogistik['nama_kurir'];
            }
            if (!empty($dataLogistik['telepon_kurir'])) {
                $pesanan->telepon_kurir = $dataLogistik['telepon_kurir'];
            }
            if (!empty($dataLogistik['nomor_resi'])) {
                $pesanan->nomor_resi = $dataLogistik['nomor_resi'];
            }
            if (!empty($dataLogistik['estimasi_jam_kirim'])) {
                $pesanan->estimasi_jam_kirim = $dataLogistik['estimasi_jam_kirim'];
            }
            return $pesanan->save();
        }
        return false;
    }
}
