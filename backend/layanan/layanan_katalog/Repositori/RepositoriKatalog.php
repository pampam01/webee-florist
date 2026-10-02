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

    public function ambilSemuaProdukAdmin(?int $idKategori = null, ?string $cari = null): Collection
    {
        $kueri = ProdukBunga::with('kategori');

        if ($idKategori !== null && $idKategori > 0) {
            $kueri->where('id_kategori', $idKategori);
        }

        if (!empty($cari)) {
            $kueri->where(function ($k) use ($cari) {
                $k->where('nama_bunga', 'like', "%{$cari}%")
                  ->orWhere('deskripsi', 'like', "%{$cari}%");
            });
        }

        return $kueri->orderBy('created_at', 'desc')->get();
    }

    public function sesuaikanStok(int $id, ?int $perubahan = null, ?int $stokBaru = null, ?bool $statusTersedia = null): ?ProdukBunga
    {
        $produk = ProdukBunga::find($id);
        if (!$produk) return null;

        if ($stokBaru !== null) {
            $produk->stok = max(0, $stokBaru);
        } elseif ($perubahan !== null) {
            $produk->stok = max(0, $produk->stok + $perubahan);
        }

        if ($statusTersedia !== null) {
            $produk->status_tersedia = $statusTersedia;
        }

        // Otomatis ubah status_tersedia jika stok 0
        if ($produk->stok === 0 && $statusTersedia === null) {
            $produk->status_tersedia = false;
        }

        $produk->save();
        return $produk->load('kategori');
    }

    public function perbaruiData(int $id, array $data): ?ProdukBunga
    {
        $produk = ProdukBunga::find($id);
        if (!$produk) return null;

        $produk->fill($data);
        if (!empty($data['nama_bunga']) && empty($data['slug'])) {
            $slug = strtolower(trim(preg_replace('/[^A-Za-z0-9-]+/', '-', $data['nama_bunga'])));
            $produk->slug = $slug . '-' . $produk->id;
        }

        $produk->save();
        return $produk->load('kategori');
    }

    public function hapusData(int $id): bool
    {
        $produk = ProdukBunga::find($id);
        if (!$produk) return false;
        return (bool) $produk->delete();
    }
}
