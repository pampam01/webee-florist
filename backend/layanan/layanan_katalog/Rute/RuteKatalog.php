<?php

namespace WebeeFlorist\Layanan\Katalog\Rute;

use Bramus\Router\Router;
use WebeeFlorist\Layanan\Katalog\Kontroller\KontrollerKatalog;

class RuteKatalog
{
    public static function daftarkan(Router $router): void
    {
        $router->mount('/api/v1/katalog', function () use ($router) {
            $kontroller = new KontrollerKatalog();

            $router->get('/kategori', function () use ($kontroller) {
                $kontroller->daftarKategori();
            });

            $router->get('/admin/produk', function () use ($kontroller) {
                $kontroller->semuaProdukAdmin();
            });

            $router->get('/produk', function () use ($kontroller) {
                $kontroller->daftarProduk();
            });

            $router->get('/produk/(\d+)', function ($id) use ($kontroller) {
                $kontroller->detailProduk((int) $id);
            });

            $router->post('/unggah', function () use ($kontroller) {
                $kontroller->unggahFoto();
            });

            $router->post('/produk', function () use ($kontroller) {
                $kontroller->tambahProduk();
            });

            $router->put('/produk/(\d+)', function ($id) use ($kontroller) {
                $kontroller->perbaruiProduk((int) $id);
            });

            $router->patch('/produk/(\d+)/stok', function ($id) use ($kontroller) {
                $kontroller->sesuaikanStok((int) $id);
            });

            $router->delete('/produk/(\d+)', function ($id) use ($kontroller) {
                $kontroller->hapusProduk((int) $id);
            });
        });
    }
}
