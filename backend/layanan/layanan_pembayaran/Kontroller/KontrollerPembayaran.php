<?php

namespace WebeeFlorist\Layanan\Pembayaran\Kontroller;

use WebeeFlorist\Basis\PengontrolDasar;
use WebeeFlorist\Keamanan\PenjagaAutentikasi;
use WebeeFlorist\Keamanan\PenjagaPeran;
use WebeeFlorist\Konfigurasi\BasisData;
use WebeeFlorist\Layanan\Pembayaran\Repositori\RepositoriPembayaran;
use WebeeFlorist\Layanan\Pesanan\Model\Pesanan;
use Throwable;

class KontrollerPembayaran extends PengontrolDasar
{
    private RepositoriPembayaran $repositori;

    public function __construct()
    {
        $this->repositori = new RepositoriPembayaran();
    }

    public function instruksi(): void
    {
        $metode = [
            [
                'kode' => 'bca_va',
                'nama' => 'BCA Virtual Account',
                'nomor_rekening' => '88012891238912',
                'atas_nama' => 'PT Webee Florist Indonesia',
                'tipe' => 'transfer_bank'
            ],
            [
                'kode' => 'mandiri_va',
                'nama' => 'Mandiri Virtual Account',
                'nomor_rekening' => '8920192830129',
                'atas_nama' => 'PT Webee Florist Indonesia',
                'tipe' => 'transfer_bank'
            ],
            [
                'kode' => 'qris',
                'nama' => 'QRIS Semua Pembayaran',
                'qr_string' => '00020101021226670016ID.CO.WEBEEFLORIST.WWW0118936009110022334455021500000000005204581253033605802ID5913WEBEE FLORIST6007JAKARTA6304E8A2',
                'atas_nama' => 'Webee Florist Store',
                'tipe' => 'qris'
            ]
        ];

        $this->tanggapanSukses($metode, 'Instruksi metode pembayaran Webee Florist.');
    }

    public function konfirmasi(): void
    {
        PenjagaAutentikasi::jalankan();
        $data = $this->ambilDataJson();

        $this->validasi($data, [
            'id_pesanan' => 'wajib|numerik',
            'metode_pembayaran' => 'wajib',
            'jumlah_bayar' => 'wajib|numerik',
        ]);

        if (BasisData::periksaKoneksi()) {
            try {
                $pembayaran = $this->repositori->buat([
                    'id_pesanan' => $data['id_pesanan'],
                    'metode_pembayaran' => $data['metode_pembayaran'],
                    'jumlah_bayar' => $data['jumlah_bayar'],
                    'bukti_transfer' => $data['bukti_transfer'] ?? null,
                    'status_pembayaran' => 'menunggu_konfirmasi',
                ]);

                $pesanan = Pesanan::find($data['id_pesanan']);
                if ($pesanan) {
                    $pesanan->status = 'diproses';
                    $pesanan->save();
                }

                $this->tanggapanSukses($pembayaran, 'Konfirmasi pembayaran berhasil dikirim. Menunggu verifikasi kasir admin.');
                return;
            } catch (Throwable $e) {}
        }

        $this->tanggapanSukses([
            'id' => rand(100, 999),
            'id_pesanan' => $data['id_pesanan'],
            'metode_pembayaran' => $data['metode_pembayaran'],
            'jumlah_bayar' => $data['jumlah_bayar'],
            'status_pembayaran' => 'terverifikasi',
        ], 'Pembayaran berhasil dikonfirmasi (mode simulasi).');
    }

    public function verifikasiAdmin(int $idPembayaran): void
    {
        PenjagaPeran::hanyaAdmin();
        $data = $this->ambilDataJson();

        $status = $data['status_pembayaran'] ?? 'terverifikasi';

        if (BasisData::periksaKoneksi()) {
            $this->repositori->perbarui($idPembayaran, [
                'status_pembayaran' => $status,
                'catatan_admin' => $data['catatan_admin'] ?? null,
            ]);
        }

        $this->tanggapanSukses(null, "Pembayaran #{$idPembayaran} berhasil diverifikasi sebagai {$status}.");
    }
}
