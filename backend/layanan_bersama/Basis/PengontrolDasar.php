<?php

namespace WebeeFlorist\Basis;

use WebeeFlorist\Utilitas\TanggapanJson;
use WebeeFlorist\Utilitas\ValidasiPermintaan;

abstract class PengontrolDasar
{
    protected function ambilDataJson(): array
    {
        $mentah = file_get_contents('php://input');
        if (empty($mentah)) {
            return $_POST ?: [];
        }

        $terurai = json_decode($mentah, true);
        return is_array($terurai) ? $terurai : [];
    }

    protected function ambilQuery(string $kunci, mixed $bawaan = null): mixed
    {
        return $_GET[$kunci] ?? $bawaan;
    }

    protected function validasi(array $data, array $aturan): void
    {
        $validator = ValidasiPermintaan::buat($data);
        if (!$validator->validasi($aturan)) {
            $validator->lemparJikaGagal();
        }
    }

    protected function tanggapanSukses(mixed $data = null, string $pesan = 'Berhasil', int $kode = 200, array $meta = []): void
    {
        TanggapanJson::sukses($data, $pesan, $kode, $meta);
    }

    protected function tanggapanGagal(string $pesan = 'Gagal', int $kode = 400, mixed $detail = null): void
    {
        TanggapanJson::gagal($pesan, $kode, $detail);
    }
}
