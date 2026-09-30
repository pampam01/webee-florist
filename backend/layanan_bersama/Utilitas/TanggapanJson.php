<?php

namespace WebeeFlorist\Utilitas;

class TanggapanJson
{
    private static ?float $waktuMulai = null;

    public static function catatWaktuMulai(): void
    {
        if (self::$waktuMulai === null) {
            self::$waktuMulai = microtime(true);
        }
    }

    public static function kirim(bool $sukses, string $pesan, mixed $data = null, int $kodeStatus = 200, array $metaTambahan = []): void
    {
        self::catatWaktuMulai();
        $waktuSelesai = microtime(true);
        $waktuEksekusiMs = round(($waktuSelesai - (self::$waktuMulai ?? $waktuSelesai)) * 1000, 2);

        $amplop = [
            'sukses' => $sukses,
            'pesan' => $pesan,
            'data' => $data,
            'meta' => array_merge([
                'kode_status' => $kodeStatus,
                'waktu_eksekusi_ms' => $waktuEksekusiMs,
                'stempel_waktu' => date('Y-m-d H:i:s'),
                'versi_api' => 'v1.0.0',
            ], $metaTambahan)
        ];

        http_response_code($kodeStatus);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($amplop, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit();
    }

    public static function sukses(mixed $data = null, string $pesan = 'Operasi berhasil dilakukan', int $kodeStatus = 200, array $meta = []): void
    {
        self::kirim(true, $pesan, $data, $kodeStatus, $meta);
    }

    public static function gagal(string $pesan = 'Terjadi kesalahan pada permintaan', int $kodeStatus = 400, mixed $detailKesalahan = null): void
    {
        $meta = [];
        if ($detailKesalahan !== null) {
            $meta['kesalahan'] = $detailKesalahan;
        }
        self::kirim(false, $pesan, null, $kodeStatus, $meta);
    }

    public static function tidakDiizinkan(string $pesan = 'Akses ditolak: Anda tidak memiliki otoritas'): void
    {
        self::gagal($pesan, 403);
    }

    public static function tidakDitemukan(string $pesan = 'Sumber daya yang diminta tidak ditemukan'): void
    {
        self::gagal($pesan, 404);
    }

    public static function kesalahanServer(string $pesan = 'Terjadi kesalahan internal pada server', mixed $detail = null): void
    {
        self::gagal($pesan, 500, $detail);
    }
}
