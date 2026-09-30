<?php

namespace WebeeFlorist\Layanan\Pembayaran\Repositori;

use WebeeFlorist\Basis\RepositoriDasar;
use WebeeFlorist\Layanan\Pembayaran\Model\Pembayaran;
use Illuminate\Database\Eloquent\Model;

class RepositoriPembayaran extends RepositoriDasar
{
    protected function ambilModel(): Model
    {
        return new Pembayaran();
    }

    public function cariBerdasarkanPesanan(int $idPesanan): ?Pembayaran
    {
        return $this->kueri()->where('id_pesanan', $idPesanan)->first();
    }
}
