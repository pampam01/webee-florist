<?php

namespace WebeeFlorist\Layanan\Katalog\Repositori;

use WebeeFlorist\Basis\RepositoriDasar;
use WebeeFlorist\Layanan\Katalog\Model\ProdukBunga;
use WebeeFlorist\Layanan\Katalog\Model\KategoriBunga;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Collection;

class RepositoriKatalog extends RepositoriDasar
{
    protected function ambilModel(): Model
    {
        return new ProdukBunga();
    }

    public function ambilSemuaKategori(): Collection
    {
        return KategoriBunga::withCount('produk')->get();
    }

    public function ambilProdukDenganFilter(?int $idKategori = null, ?string $cari = null, ?bool $unggulan = null): Collection
    {
        $kueri = ProdukBunga::with('kategori')->where('status_tersedia', true);

        if ($idKategori !== null && $idKategori > 0) {
            $kueri->where('id_kategori', $idKategori);
        }

        if (!empty($cari)) {
            $kueri->where(function ($k) use ($cari) {
                $k->where('nama_bunga', 'like', "%{$cari}%")
                  ->orWhere('deskripsi', 'like', "%{$cari}%");
            });
        }

        if ($unggulan !== null) {
            $kueri->where('apakah_unggulan', $unggulan);
        }

        return $kueri->orderBy('created_at', 'desc')->get();
    }

    public function ambilDetailProduk(int $id): ?ProdukBunga
    {
        return ProdukBunga::with('kategori')->find($id);
    }
}
