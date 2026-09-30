<?php

namespace WebeeFlorist\Layanan\Keranjang\Rute;

use Bramus\Router\Router;
use WebeeFlorist\Layanan\Keranjang\Kontroller\KontrollerKeranjang;

class RuteKeranjang
{
    public static function daftarkan(Router $router): void
    {
        $router->mount('/api/v1/keranjang', function () use ($router) {
            $kontroller = new KontrollerKeranjang();

            $router->get('/', function () use ($kontroller) {
                $kontroller->lihat();
            });

            $router->post('/', function () use ($kontroller) {
                $kontroller->tambah();
            });

            $router->delete('/(\d+)', function ($id) use ($kontroller) {
                $kontroller->hapus((int) $id);
            });

            $router->delete('/bersihkan', function () use ($kontroller) {
                $kontroller->bersihkan();
            });
        });
    }
}
