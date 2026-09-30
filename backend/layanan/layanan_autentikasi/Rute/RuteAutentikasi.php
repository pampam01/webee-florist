<?php

namespace WebeeFlorist\Layanan\Autentikasi\Rute;

use Bramus\Router\Router;
use WebeeFlorist\Layanan\Autentikasi\Kontroller\KontrollerAutentikasi;

class RuteAutentikasi
{
    public static function daftarkan(Router $router): void
    {
        $router->mount('/api/v1/autentikasi', function () use ($router) {
            $kontroller = new KontrollerAutentikasi();

            $router->post('/masuk', function () use ($kontroller) {
                $kontroller->masuk();
            });

            $router->post('/daftar', function () use ($kontroller) {
                $kontroller->daftar();
            });

            $router->get('/profil', function () use ($kontroller) {
                $kontroller->profil();
            });
        });
    }
}
