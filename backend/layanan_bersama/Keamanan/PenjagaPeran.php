<?php

namespace WebeeFlorist\Keamanan;

use WebeeFlorist\Utilitas\TanggapanJson;

class PenjagaPeran
{
    public static function hanyaAdmin(): object
    {
        $pengguna = PenjagaAutentikasi::jalankan();

        if (($pengguna->peran ?? '') !== 'admin') {
            TanggapanJson::tidakDiizinkan('Akses ditolak: Operasi ini hanya diizinkan untuk Admin Webee Florist');
        }

        return $pengguna;
    }

    public static function hanyaPelanggan(): object
    {
        $pengguna = PenjagaAutentikasi::jalankan();

        if (($pengguna->peran ?? '') !== 'pelanggan' && ($pengguna->peran ?? '') !== 'admin') {
            TanggapanJson::tidakDiizinkan('Akses ditolak: Operasi ini membutuhkan peran Pelanggan');
        }

        return $pengguna;
    }
}
