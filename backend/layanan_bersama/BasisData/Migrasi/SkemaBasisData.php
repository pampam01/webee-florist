<?php

namespace WebeeFlorist\BasisData\Migrasi;

use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Database\Schema\Blueprint;
use WebeeFlorist\Konfigurasi\BasisData;

class SkemaBasisData
{
    public static function jalankan(): void
    {
        BasisData::inisialisasi();
        $skema = Capsule::schema();

        echo "[MIGRASI] Memulai sinkronisasi skema tabel basis data...\n";

        // 1. Pengguna
        if (!$skema->hasTable('pengguna')) {
            $skema->create('pengguna', function (Blueprint $tabel) {
                $tabel->id();
                $tabel->string('nama', 100);
                $tabel->string('email', 150)->unique();
                $tabel->string('kata_sandi');
                $tabel->string('nomor_telepon', 20)->nullable();
                $tabel->text('alamat')->nullable();
                $tabel->string('peran', 20)->default('pelanggan');
                $tabel->timestamps();
            });
            echo "  ✓ Tabel 'pengguna' berhasil dibuat.\n";
        }

        // 2. Kategori Bunga
        if (!$skema->hasTable('kategori_bunga')) {
            $skema->create('kategori_bunga', function (Blueprint $tabel) {
                $tabel->id();
                $tabel->string('nama_kategori', 100);
                $tabel->string('slug', 100)->unique();
                $tabel->text('deskripsi')->nullable();
                $tabel->string('ikon', 100)->nullable();
                $tabel->timestamps();
            });
            echo "  ✓ Tabel 'kategori_bunga' berhasil dibuat.\n";
        }

        // 3. Produk Bunga
        if (!$skema->hasTable('produk_bunga')) {
            $skema->create('produk_bunga', function (Blueprint $tabel) {
                $tabel->id();
                $tabel->unsignedBigInteger('id_kategori')->nullable();
                $tabel->string('nama_bunga', 150);
                $tabel->string('slug', 150)->unique();
                $tabel->text('deskripsi')->nullable();
                $tabel->decimal('harga', 15, 2);
                $tabel->integer('stok')->default(0);
                $tabel->string('gambar_url', 500)->nullable();
                $tabel->text('foto_galeri')->nullable();
                $tabel->boolean('apakah_unggulan')->default(false);
                $tabel->boolean('status_tersedia')->default(true);
                $tabel->timestamps();

                $tabel->foreign('id_kategori')->references('id')->on('kategori_bunga')->onDelete('set null');
            });
            echo "  ✓ Tabel 'produk_bunga' berhasil dibuat.\n";
        } else if ($skema->hasTable('produk_bunga') && !$skema->hasColumn('produk_bunga', 'foto_galeri')) {
            $skema->table('produk_bunga', function (Blueprint $tabel) {
                $tabel->text('foto_galeri')->nullable()->after('gambar_url');
            });
            echo "  ✓ Kolom 'foto_galeri' berhasil ditambahkan ke 'produk_bunga'.\n";
        }

        // 4. Item Keranjang
        if (!$skema->hasTable('item_keranjang')) {
            $skema->create('item_keranjang', function (Blueprint $tabel) {
                $tabel->id();
                $tabel->unsignedBigInteger('id_pengguna');
                $tabel->unsignedBigInteger('id_produk');
                $tabel->integer('kuantitas')->default(1);
                $tabel->text('catatan_khusus')->nullable();
                $tabel->timestamps();

                $tabel->foreign('id_pengguna')->references('id')->on('pengguna')->onDelete('cascade');
                $tabel->foreign('id_produk')->references('id')->on('produk_bunga')->onDelete('cascade');
            });
            echo "  ✓ Tabel 'item_keranjang' berhasil dibuat.\n";
        }

        // 5. Pesanan
        if (!$skema->hasTable('pesanan')) {
            $skema->create('pesanan', function (Blueprint $tabel) {
                $tabel->id();
                $tabel->string('nomor_pesanan', 50)->unique();
                $tabel->unsignedBigInteger('id_pelanggan');
                $tabel->decimal('total_harga', 15, 2);
                $tabel->string('status', 30)->default('menunggu_pembayaran');
                $tabel->string('nama_penerima', 100);
                $tabel->string('telepon_penerima', 20);
                $tabel->text('alamat_pengiriman');
                $tabel->text('kartu_ucapan')->nullable();
                $tabel->date('tanggal_pengiriman')->nullable();
                $tabel->string('jenis_kurir', 50)->nullable();
                $tabel->string('nama_kurir', 100)->nullable();
                $tabel->string('telepon_kurir', 30)->nullable();
                $tabel->string('nomor_resi', 100)->nullable();
                $tabel->string('estimasi_jam_kirim', 50)->nullable();
                $tabel->timestamps();

                $tabel->foreign('id_pelanggan')->references('id')->on('pengguna')->onDelete('cascade');
            });
            echo "  ✓ Tabel 'pesanan' berhasil dibuat.\n";
        } else {
            $skema->table('pesanan', function (Blueprint $tabel) use ($skema) {
                if (!$skema->hasColumn('pesanan', 'jenis_kurir')) {
                    $tabel->string('jenis_kurir', 50)->nullable()->after('tanggal_pengiriman');
                }
                if (!$skema->hasColumn('pesanan', 'nama_kurir')) {
                    $tabel->string('nama_kurir', 100)->nullable()->after('jenis_kurir');
                }
                if (!$skema->hasColumn('pesanan', 'telepon_kurir')) {
                    $tabel->string('telepon_kurir', 30)->nullable()->after('nama_kurir');
                }
                if (!$skema->hasColumn('pesanan', 'nomor_resi')) {
                    $tabel->string('nomor_resi', 100)->nullable()->after('telepon_kurir');
                }
                if (!$skema->hasColumn('pesanan', 'estimasi_jam_kirim')) {
                    $tabel->string('estimasi_jam_kirim', 50)->nullable()->after('nomor_resi');
                }
            });
            echo "  ✓ Kolom logistik pengiriman pada tabel 'pesanan' berhasil diverifikasi.\n";
        }

        // 6. Item Pesanan
        if (!$skema->hasTable('item_pesanan')) {
            $skema->create('item_pesanan', function (Blueprint $tabel) {
                $tabel->id();
                $tabel->unsignedBigInteger('id_pesanan');
                $tabel->unsignedBigInteger('id_produk');
                $tabel->string('nama_produk', 150);
                $tabel->decimal('harga_satuan', 15, 2);
                $tabel->integer('kuantitas');
                $tabel->decimal('subtotal', 15, 2);
                $tabel->timestamps();

                $tabel->foreign('id_pesanan')->references('id')->on('pesanan')->onDelete('cascade');
            });
            echo "  ✓ Tabel 'item_pesanan' berhasil dibuat.\n";
        }

        // 7. Pembayaran
        if (!$skema->hasTable('pembayaran')) {
            $skema->create('pembayaran', function (Blueprint $tabel) {
                $tabel->id();
                $tabel->unsignedBigInteger('id_pesanan');
                $tabel->string('metode_pembayaran', 50);
                $tabel->decimal('jumlah_bayar', 15, 2);
                $tabel->string('bukti_transfer', 500)->nullable();
                $tabel->string('status_pembayaran', 30)->default('menunggu_konfirmasi');
                $tabel->text('catatan_admin')->nullable();
                $tabel->timestamps();

                $tabel->foreign('id_pesanan')->references('id')->on('pesanan')->onDelete('cascade');
            });
            echo "  ✓ Tabel 'pembayaran' berhasil dibuat.\n";
        }

        echo "[MIGRASI] Selesai! Semua tabel siap digunakan.\n";
    }
}
