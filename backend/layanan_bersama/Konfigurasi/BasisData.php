<?php

namespace WebeeFlorist\Konfigurasi;

use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Events\Dispatcher;
use Illuminate\Container\Container;

class BasisData
{
    private static ?Capsule $kapsul = null;

    public static function inisialisasi(): Capsule
    {
        if (self::$kapsul !== null) {
            return self::$kapsul;
        }

        Aplikasi::inisialisasi();

        $kapsul = new Capsule();
        $koneksi = Aplikasi::ambil('DB_KONEKSI', 'mysql');

        if ($koneksi === 'sqlite') {
            $pathSqlite = Aplikasi::ambil('DB_BASISDATA', dirname(__DIR__, 2) . '/penyimpanan/database.sqlite');
            $direktori = dirname($pathSqlite);
            if (!is_dir($direktori)) {
                mkdir($direktori, 0777, true);
            }
            if (!file_exists($pathSqlite)) {
                touch($pathSqlite);
            }
            $konfigurasi = [
                'driver'   => 'sqlite',
                'database' => $pathSqlite,
                'prefix'   => Aplikasi::ambil('DB_PREFIX', ''),
            ];
        } else {
            $konfigurasi = [
                'driver'    => 'mysql',
                'host'      => Aplikasi::ambil('DB_HOST', '127.0.0.1'),
                'port'      => Aplikasi::ambil('DB_PORT', '3306'),
                'database'  => Aplikasi::ambil('DB_BASISDATA', 'webee_florist'),
                'username'  => Aplikasi::ambil('DB_PENGGUNA', 'root'),
                'password'  => Aplikasi::ambil('DB_KATASANDI', ''),
                'charset'   => Aplikasi::ambil('DB_CHARSET', 'utf8mb4'),
                'collation' => Aplikasi::ambil('DB_COLLATION', 'utf8mb4_unicode_ci'),
                'prefix'    => Aplikasi::ambil('DB_PREFIX', ''),
                'strict'    => true,
                'engine'    => 'InnoDB',
                'options'   => [
                    \PDO::ATTR_TIMEOUT => 3,
                    \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION,
                ]
            ];
        }

        $kapsul->addConnection($konfigurasi);
        $kapsul->setEventDispatcher(new Dispatcher(new Container()));
        $kapsul->setAsGlobal();
        $kapsul->bootEloquent();

        self::$kapsul = $kapsul;
        return self::$kapsul;
    }

    public static function periksaKoneksi(): bool
    {
        try {
            self::inisialisasi()->getConnection()->getPdo();
            return true;
        } catch (\Throwable $e) {
            return false;
        }
    }

    public static function ambilKapsul(): Capsule
    {
        return self::inisialisasi();
    }
}
