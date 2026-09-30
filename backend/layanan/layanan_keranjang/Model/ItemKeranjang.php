<?php

namespace WebeeFlorist\Layanan\Keranjang\Model;

use WebeeFlorist\Basis\ModelDasar;
use WebeeFlorist\Layanan\Katalog\Model\ProdukBunga;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ItemKeranjang extends ModelDasar
{
    protected $table = 'item_keranjang';

    protected $fillable = [
        'id_pengguna',
        'id_produk',
        'kuantitas',
        'catatan_khusus',
    ];

    protected $casts = [
        'id' => 'integer',
        'id_pengguna' => 'integer',
        'id_produk' => 'integer',
        'kuantitas' => 'integer',
    ];

    public function produk(): BelongsTo
    {
        return $this->belongsTo(ProdukBunga::class, 'id_produk', 'id');
    }
}
