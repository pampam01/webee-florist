<?php

namespace WebeeFlorist\BasisData\Pembenih;

use Illuminate\Database\Capsule\Manager as Capsule;
use WebeeFlorist\Konfigurasi\BasisData;

class BenihAwal
{
    public static function jalankan(): void
    {
        BasisData::inisialisasi();
        echo "[BENIH] Memulai penanaman data awal...\n";

        // 1. Pengguna
        if (Capsule::table('pengguna')->count() === 0) {
            Capsule::table('pengguna')->insert([
                [
                    'nama' => 'Administrator Webee Florist',
                    'email' => 'admin@webeeflorist.com',
                    'kata_sandi' => password_hash('admin123', PASSWORD_BCRYPT),
                    'nomor_telepon' => '081234567890',
                    'alamat' => 'Kantor Pusat Webee Florist, Jakarta',
                    'peran' => 'admin',
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ],
                [
                    'nama' => 'Siti Pelanggan Setia',
                    'email' => 'pelanggan@webeeflorist.com',
                    'kata_sandi' => password_hash('pelanggan123', PASSWORD_BCRYPT),
                    'nomor_telepon' => '089876543210',
                    'alamat' => 'Jl. Mawar Indah No. 12, Jakarta Selatan',
                    'peran' => 'pelanggan',
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ]
            ]);
            echo "  ✓ Data Pengguna (Admin & Pelanggan) berhasil ditambahkan.\n";
        }

        // 2. Kategori
        if (Capsule::table('kategori_bunga')->count() === 0) {
            Capsule::table('kategori_bunga')->insert([
                [
                    'id' => 1,
                    'nama_kategori' => 'Buket Mawar Romantis',
                    'slug' => 'buket-mawar-romantis',
                    'deskripsi' => 'Rangkaian mawar premium pilihan untuk momen kasih sayang dan ulang tahun.',
                    'ikon' => 'rose',
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ],
                [
                    'id' => 2,
                    'nama_kategori' => 'Bunga Meja & Vas',
                    'slug' => 'bunga-meja-vas',
                    'deskripsi' => 'Dekorasi bunga segar untuk mempercantik ruang tamu, kantor, dan meja kerja.',
                    'ikon' => 'table_view',
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ],
                [
                    'id' => 3,
                    'nama_kategori' => 'Buket Wisuda & Kelulusan',
                    'slug' => 'buket-wisuda-kelulusan',
                    'deskripsi' => 'Hadiah bunga ceria penuh makna untuk merayakan kelulusan dan prestasi.',
                    'ikon' => 'school',
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ],
                [
                    'id' => 4,
                    'nama_kategori' => 'Bunga Papan Ucapan',
                    'slug' => 'bunga-papan-ucapan',
                    'deskripsi' => 'Bunga papan megah untuk grand opening, pernikahan, dan ucapan duka cita.',
                    'ikon' => 'celebration',
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ],
            ]);
            echo "  ✓ Data Kategori Bunga berhasil ditambahkan.\n";
        }

        // 3. Produk
        if (Capsule::table('produk_bunga')->count() === 0) {
            Capsule::table('produk_bunga')->insert([
                [
                    'id_kategori' => 1,
                    'nama_bunga' => 'Buket Red Velvet Rose Symphony',
                    'slug' => 'buket-red-velvet-rose-symphony',
                    'deskripsi' => 'Koleksi 20 tangkai mawar merah beludru super impor dengan balutan wrapping hitam emas elegan.',
                    'harga' => 350000.00,
                    'stok' => 25,
                    'gambar_url' => 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=600&q=80',
                    'apakah_unggulan' => true,
                    'status_tersedia' => true,
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ],
                [
                    'id_kategori' => 1,
                    'nama_bunga' => 'Pink Blush Mawar Belanda',
                    'slug' => 'pink-blush-mawar-belanda',
                    'deskripsi' => 'Kombinasi mawar merah muda lembut dengan dedaunan eucalyptus aromatik.',
                    'harga' => 275000.00,
                    'stok' => 18,
                    'gambar_url' => 'https://images.unsplash.com/photo-1561181286-d3fee7d55364?auto=format&fit=crop&w=600&q=80',
                    'apakah_unggulan' => true,
                    'status_tersedia' => true,
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ],
                [
                    'id_kategori' => 2,
                    'nama_bunga' => 'Vas Kaca Lily Casablanca Putih',
                    'slug' => 'vas-kaca-lily-casablanca-putih',
                    'deskripsi' => 'Bunga Lily Casablanca putih harum dalam vas kaca kristal mewah untuk keindahan interior.',
                    'harga' => 450000.00,
                    'stok' => 12,
                    'gambar_url' => 'https://images.unsplash.com/photo-1526047932273-341f2a7631f9?auto=format&fit=crop&w=600&q=80',
                    'apakah_unggulan' => true,
                    'status_tersedia' => true,
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ],
                [
                    'id_kategori' => 3,
                    'nama_bunga' => 'Buket Wisuda Matahari Ceria & Boneka',
                    'slug' => 'buket-wisuda-matahari-ceria-boneka',
                    'deskripsi' => 'Bunga matahari segar melambangkan kesuksesan dilengkapi boneka wisuda lucu dan selempang ucapan.',
                    'harga' => 220000.00,
                    'stok' => 30,
                    'gambar_url' => 'https://images.unsplash.com/photo-1597848212624-a19eb35e2651?auto=format&fit=crop&w=600&q=80',
                    'apakah_unggulan' => false,
                    'status_tersedia' => true,
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ],
                [
                    'id_kategori' => 4,
                    'nama_bunga' => 'Papan Bunga Grand Opening Sukses Mulia',
                    'slug' => 'papan-bunga-grand-opening-sukses-mulia',
                    'deskripsi' => 'Ukuran 2 x 1.25 meter dengan susunan bunga suyok dan aster segar full keliling.',
                    'harga' => 600000.00,
                    'stok' => 10,
                    'gambar_url' => 'https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=600&q=80',
                    'apakah_unggulan' => false,
                    'status_tersedia' => true,
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ],
            ]);
            echo "  ✓ Data Produk Bunga Webee Florist berhasil ditambahkan.\n";
        }

        echo "[BENIH] Penanaman data awal selesai dengan sukses!\n";
    }
}
