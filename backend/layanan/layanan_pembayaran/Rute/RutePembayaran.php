<?php

namespace WebeeFlorist\Layanan\Pembayaran\Rute;

use Bramus\Router\Router;
use WebeeFlorist\Layanan\Pembayaran\Kontroller\KontrollerPembayaran;

class RutePembayaran
{
    public static function daftarkan(Router $router): void
    {
        $router->mount('/api/v1/pembayaran', function () use ($router) {
            $kontroller = new KontrollerPembayaran();

            $router->get('/instruksi', function () use ($kontroller) {
                $kontroller->instruksi();
            });

            $router->post('/konfirmasi', function () use ($kontroller) {
                $kontroller->konfirmasi();
            });

            $router->patch('/(\d+)/verifikasi', function ($id) use ($kontroller) {
                $kontroller->verifikasiAdmin((int) $id);
            });
        });
    }
}
