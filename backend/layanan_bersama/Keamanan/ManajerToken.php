<?php

namespace WebeeFlorist\Keamanan;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use WebeeFlorist\Konfigurasi\Aplikasi;
use Throwable;

class ManajerToken
{
    private static string $algoritma = 'HS256';

    public static function buatToken(int $idPengguna, string $email, string $nama, string $peran): string
    {
        $kunciRahasia = Aplikasi::ambilKunciJwt();
        $masaBerlaku = Aplikasi::masaBerlakuJwt();
        $waktuSekarang = time();

        $muatan = [
            'iss' => Aplikasi::ambil('NAMA_APLIKASI', 'Webee Florist API'),
            'iat' => $waktuSekarang,
            'exp' => $waktuSekarang + $masaBerlaku,
            'data' => [
                'id_pengguna' => $idPengguna,
                'email'       => $email,
                'nama'        => $nama,
                'peran'       => $peran,
            ]
        ];

        return JWT::encode($muatan, $kunciRahasia, self::$algoritma);
    }

    public static function verifikasiToken(string $token): ?object
    {
        try {
            $kunciRahasia = Aplikasi::ambilKunciJwt();
            $terdekode = JWT::decode($token, new Key($kunciRahasia, self::$algoritma));
            return $terdekode->data;
        } catch (Throwable $e) {
            return null;
        }
    }

    public static function ambilTokenDariHeader(): ?string
    {
        $header = $_SERVER['HTTP_AUTHORIZATION'] ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION'] ?? '';

        if (empty($header) && function_exists('apache_request_headers')) {
            $semuaHeader = apache_request_headers();
            $header = $semuaHeader['Authorization'] ?? $semuaHeader['authorization'] ?? '';
        }

        if (preg_match('/Bearer\s(\S+)/', $header, $cocokan)) {
            return $cocokan[1];
        }

        return null;
    }
}
