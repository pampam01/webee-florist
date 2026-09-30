<?php

namespace WebeeFlorist\Layanan\Pembayaran\Model;

use WebeeFlorist\Basis\ModelDasar;
use WebeeFlorist\Layanan\Pesanan\Model\Pesanan;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Pembayaran extends ModelDasar
{
    protected $table = 'pembayaran';

    protected $fillable = [
        'id_pesanan',
        'metode_pembayaran',
        'jumlah_bayar',
        'bukti_transfer',
        'status_pembayaran',
        'catatan_admin',
    ];

    protected $casts = [
        'id' => 'integer',
        'id_pesanan' => 'integer',
        'jumlah_bayar' => 'float',
    ];

    public function pesanan(): BelongsTo
    {
        return $this->belongsTo(Pesanan::class, 'id_pesanan', 'id');
    }
}
