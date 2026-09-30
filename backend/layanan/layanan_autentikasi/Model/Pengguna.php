<?php

namespace WebeeFlorist\Layanan\Autentikasi\Model;

use WebeeFlorist\Basis\ModelDasar;

class Pengguna extends ModelDasar
{
    protected $table = 'pengguna';

    protected $fillable = [
        'nama',
        'email',
        'kata_sandi',
        'nomor_telepon',
        'alamat',
        'peran',
    ];

    protected $hidden = [
        'kata_sandi',
    ];

    protected $casts = [
        'id' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    public function apakahAdmin(): bool
    {
        return $this->peran === 'admin';
    }

    public function apakahPelanggan(): bool
    {
        return $this->peran === 'pelanggan';
    }
}
