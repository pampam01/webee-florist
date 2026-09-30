<?php

namespace WebeeFlorist\Layanan\Pesanan\Model;

use WebeeFlorist\Basis\ModelDasar;
use WebeeFlorist\Layanan\Katalog\Model\ProdukBunga;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ItemPesanan extends ModelDasar
{
    protected $table = 'item_pesanan';

    protected $fillable = [
        'id_pesanan',
        'id_produk',
        'nama_produk',
        'harga_satuan',
        'kuantitas',
        'subtotal',
    ];

    protected $casts = [
        'id' => 'integer',
        'id_pesanan' => 'integer',
        'id_produk' => 'integer',
        'harga_satuan' => 'float',
        'kuantitas' => 'integer',
        'subtotal' => 'float',
    ];

    public function pesanan(): BelongsTo
    {
        return $this->belongsTo(Pesanan::class, 'id_pesanan', 'id');
    }

    public function produk(): BelongsTo
    {
        return $this->belongsTo(ProdukBunga::class, 'id_produk', 'id');
    }
}
