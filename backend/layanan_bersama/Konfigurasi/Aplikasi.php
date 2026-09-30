<?php

namespace WebeeFlorist\Konfigurasi;

use Dotenv\Dotenv;

/**
 * Kelas Konfigurasi Aplikasi Inti
 * Memuat variabel lingkungan (.env) dan konstanta global sistem.
 */
class Aplikasi
{
    private static bool $sudahDimuat = false;

    public static function inisialisasi(): void
    {
        if (self::$sudahDimuat) {
            return;
        }

        self::$sudahDimuat = true;

        $direktoriRoot = dirname(__DIR__, 2);
        if (file_exists($direktoriRoot . '/.env')) {
            $dotenv = Dotenv::createImmutable($direktoriRoot);
            $dotenv->safeLoad();
        }

        date_default_timezone_set($_ENV['ZONA_WAKTU'] ?? $_SERVER['ZONA_WAKTU'] ?? 'Asia/Jakarta');
    }

    public static function ambil(string $kunci, mixed $nilaiBawaan = null): mixed
    {
        self::inisialisasi();
        return $_ENV[$kunci] ?? $_SERVER[$kunci] ?? $nilaiBawaan;
    }

    public static function apakahDebug(): bool
    {
        return filter_var(self::ambil('DEBUG', false), FILTER_VALIDATE_BOOLEAN);
    }

    public static function ambilKunciJwt(): string
    {
        return (string) self::ambil('KUNCI_RAHASIA_JWT', 'kunci_rahasia_bawaan_webee_florist');
    }

    public static function masaBerlakuJwt(): int
    {
        return (int) self::ambil('KADALUARSA_TOKEN_DETIK', 86400);
    }
}
