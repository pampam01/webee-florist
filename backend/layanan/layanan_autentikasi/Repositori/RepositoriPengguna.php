<?php

namespace WebeeFlorist\Layanan\Autentikasi\Repositori;

use WebeeFlorist\Basis\RepositoriDasar;
use WebeeFlorist\Layanan\Autentikasi\Model\Pengguna;
use Illuminate\Database\Eloquent\Model;

class RepositoriPengguna extends RepositoriDasar
{
    protected function ambilModel(): Model
    {
        return new Pengguna();
    }

    public function cariBerdasarkanEmail(string $email): ?Pengguna
    {
        return $this->kueri()->where('email', $email)->first();
    }

    public function apakahEmailTerdaftar(string $email): bool
    {
        return $this->kueri()->where('email', $email)->exists();
    }
}
