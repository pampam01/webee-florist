<?php

namespace WebeeFlorist\Layanan\Pesanan\Rute;

use Bramus\Router\Router;
use WebeeFlorist\Layanan\Pesanan\Kontroller\KontrollerPesanan;

class RutePesanan
{
    public static function daftarkan(Router $router): void
    {
        $router->mount('/api/v1/pesanan', function () use ($router) {
            $kontroller = new KontrollerPesanan();

            $router->post('/', function () use ($kontroller) {
                $kontroller->buatPesanan();
            });

            $router->get('/riwayat', function () use ($kontroller) {
                $kontroller->riwayat();
            });

            $router->get('/admin/semua', function () use ($kontroller) {
                $kontroller->semuaPesananAdmin();
            });

            $router->get('/(\d+)', function ($id) use ($kontroller) {
                $kontroller->detail((int) $id);
            });

            $router->patch('/(\d+)/status', function ($id) use ($kontroller) {
                $kontroller->ubahStatus((int) $id);
            });
        });
    }
}
