<?php

namespace WebeeFlorist\Layanan\Katalog\Model;

use WebeeFlorist\Basis\ModelDasar;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProdukBunga extends ModelDasar
{
    protected $table = 'produk_bunga';

    protected $fillable = [
        'id_kategori',
        'nama_bunga',
        'slug',
        'deskripsi',
        'harga',
        'stok',
        'gambar_url',
        'foto_galeri',
        'apakah_unggulan',
        'status_tersedia',
    ];

    protected $casts = [
        'id' => 'integer',
        'id_kategori' => 'integer',
        'harga' => 'float',
        'stok' => 'integer',
        'foto_galeri' => 'array',
        'apakah_unggulan' => 'boolean',
        'status_tersedia' => 'boolean',
    ];

    public function kategori(): BelongsTo
    {
        return $this->belongsTo(KategoriBunga::class, 'id_kategori', 'id');
    }
}
