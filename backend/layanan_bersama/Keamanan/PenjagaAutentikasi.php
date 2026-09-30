<?php

namespace WebeeFlorist\Keamanan;

use WebeeFlorist\Utilitas\TanggapanJson;

class PenjagaAutentikasi
{
    private static ?object $penggunaSaatIni = null;

    public static function jalankan(): object
    {
        $token = ManajerToken::ambilTokenDariHeader();

        if (!$token) {
            TanggapanJson::gagal('Akses ditolak: Token autentikasi tidak ditemukan di header', 401);
        }

        $pengguna = ManajerToken::verifikasiToken($token);

        if (!$pengguna) {
            TanggapanJson::gagal('Akses ditolak: Token tidak valid atau telah kadaluarsa', 401);
        }

        self::$penggunaSaatIni = $pengguna;
        return $pengguna;
    }

    public static function ambilPengguna(): ?object
    {
        return self::$penggunaSaatIni;
    }
}
