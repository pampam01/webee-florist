<?php

namespace WebeeFlorist\Layanan\Katalog\Model;

use WebeeFlorist\Basis\ModelDasar;
use Illuminate\Database\Eloquent\Relations\HasMany;

class KategoriBunga extends ModelDasar
{
    protected $table = 'kategori_bunga';

    protected $fillable = [
        'nama_kategori',
        'slug',
        'deskripsi',
        'ikon',
    ];

    public function produk(): HasMany
    {
        return $this->hasMany(ProdukBunga::class, 'id_kategori', 'id');
    }
}
