<?php

namespace WebeeFlorist\Layanan\Keranjang\Repositori;

use WebeeFlorist\Basis\RepositoriDasar;
use WebeeFlorist\Layanan\Keranjang\Model\ItemKeranjang;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Collection;

class RepositoriKeranjang extends RepositoriDasar
{
    protected function ambilModel(): Model
    {
        return new ItemKeranjang();
    }

    public function ambilKeranjangPengguna(int $idPengguna): Collection
    {
        return ItemKeranjang::with('produk')->where('id_pengguna', $idPengguna)->get();
    }

    public function simpanAtauPerbarui(int $idPengguna, int $idProduk, int $tambahKuantitas, ?string $catatan = null): ItemKeranjang
    {
        $item = ItemKeranjang::where('id_pengguna', $idPengguna)
            ->where('id_produk', $idProduk)
            ->first();

        if ($item) {
            $item->kuantitas += $tambahKuantitas;
            if ($catatan !== null) {
                $item->catatan_khusus = $catatan;
            }
            $item->save();
            return $item;
        }

        return ItemKeranjang::create([
            'id_pengguna' => $idPengguna,
            'id_produk' => $idProduk,
            'kuantitas' => $tambahKuantitas,
            'catatan_khusus' => $catatan,
        ]);
    }

    public function bersihkanKeranjang(int $idPengguna): int
    {
        return ItemKeranjang::where('id_pengguna', $idPengguna)->delete();
    }
}
