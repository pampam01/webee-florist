<?php

namespace WebeeFlorist\Keamanan;

use WebeeFlorist\Konfigurasi\Aplikasi;
use WebeeFlorist\Utilitas\TanggapanJson;

class PenjagaAutentikasi
{
    private static ?object $penggunaSaatIni = null;

    public static function jalankan(): object
    {
        $token = ManajerToken::ambilTokenDariHeader();

        if (!$token) {
            // Jika dalam lingkungan lokal/pengembangan, izinkan sesi dev admin default
            if (Aplikasi::ambil('LINGKUNGAN') === 'lokal' || Aplikasi::apakahDebug()) {
                $penggunaDev = (object) [
                    'id_pengguna' => 1,
                    'email'       => 'admin@webeeflorist.com',
                    'nama'        => 'Atelier Webee Florist',
                    'peran'       => 'admin',
                ];
                self::$penggunaSaatIni = $penggunaDev;
                return $penggunaDev;
            }

            TanggapanJson::gagal('Akses ditolak: Token autentikasi tidak ditemukan di header', 401);
        }

        $pengguna = ManajerToken::verifikasiToken($token);

        if (!$pengguna) {
            if (Aplikasi::ambil('LINGKUNGAN') === 'lokal' || Aplikasi::apakahDebug()) {
                $penggunaDev = (object) [
                    'id_pengguna' => 1,
                    'email'       => 'admin@webeeflorist.com',
                    'nama'        => 'Atelier Webee Florist',
                    'peran'       => 'admin',
                ];
                self::$penggunaSaatIni = $penggunaDev;
                return $penggunaDev;
            }

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
