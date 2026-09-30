<?php

namespace WebeeFlorist\Basis;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use WebeeFlorist\Konfigurasi\BasisData;

abstract class RepositoriDasar
{
    abstract protected function ambilModel(): Model;

    protected function kueri(): Builder
    {
        return $this->ambilModel()->newQuery();
    }

    public function semua(array $kolom = ['*']): Collection
    {
        return $this->kueri()->get($kolom);
    }

    public function cariBerdasarkanId(int $id, array $kolom = ['*']): ?Model
    {
        return $this->kueri()->find($id, $kolom);
    }

    public function buat(array $atribut): Model
    {
        return $this->kueri()->create($atribut);
    }

    public function perbarui(int $id, array $atribut): bool
    {
        $data = $this->cariBerdasarkanId($id);
        return $data ? $data->update($atribut) : false;
    }

    public function hapus(int $id): bool
    {
        $data = $this->cariBerdasarkanId($id);
        return $data ? (bool) $data->delete() : false;
    }

    public function paginasi(int $perHalaman = 15, int $halaman = 1, array $kolom = ['*']): array
    {
        $kueri = $this->kueri();
        $total = $kueri->count();
        $item = $kueri->forPage($halaman, $perHalaman)->get($kolom);

        return [
            'item' => $item,
            'paginasi' => [
                'total' => $total,
                'per_halaman' => $perHalaman,
                'halaman_saat_ini' => $halaman,
                'total_halaman' => (int) ceil($total / max(1, $perHalaman)),
            ]
        ];
    }

    public function transaksi(callable $eksekusi): mixed
    {
        return BasisData::ambilKapsul()->getConnection()->transaction($eksekusi);
    }
}
