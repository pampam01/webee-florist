<?php

namespace WebeeFlorist\Layanan\Pesanan\Model;

use WebeeFlorist\Basis\ModelDasar;
use WebeeFlorist\Layanan\Autentikasi\Model\Pengguna;
use WebeeFlorist\Layanan\Pembayaran\Model\Pembayaran;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Pesanan extends ModelDasar
{
    protected $table = 'pesanan';

    protected $fillable = [
        'nomor_pesanan',
        'id_pelanggan',
        'total_harga',
        'status',
        'nama_penerima',
        'telepon_penerima',
        'alamat_pengiriman',
        'kartu_ucapan',
        'tanggal_pengiriman',
    ];

    protected $casts = [
        'id' => 'integer',
        'id_pelanggan' => 'integer',
        'total_harga' => 'float',
        'tanggal_pengiriman' => 'date',
    ];

    public function item(): HasMany
    {
        return $this->hasMany(ItemPesanan::class, 'id_pesanan', 'id');
    }

    public function pelanggan(): BelongsTo
    {
        return $this->belongsTo(Pengguna::class, 'id_pelanggan', 'id');
    }

    public function pembayaran(): HasOne
    {
        return $this->hasOne(Pembayaran::class, 'id_pesanan', 'id');
    }
}
