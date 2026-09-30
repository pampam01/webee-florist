<?php

namespace WebeeFlorist\Layanan\Admin\Rute;

use Bramus\Router\Router;
use WebeeFlorist\Layanan\Admin\Kontroller\KontrollerAdmin;

class RuteAdmin
{
    public static function daftarkan(Router $router): void
    {
        $router->mount('/api/v1/admin', function () use ($router) {
            $kontroller = new KontrollerAdmin();

            $router->get('/dashboard', function () use ($kontroller) {
                $kontroller->ringkasanDashboard();
            });
        });
    }
}
