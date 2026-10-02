<?php

declare(strict_types=1);

namespace WebeeFlorist\Layanan\Katalog\Layanan;

class LayananUnggahBerkas
{
    private const EKSTENSI_DIIZINKAN = ['jpg', 'jpeg', 'png', 'webp', 'gif'];
    private const MIME_DIIZINKAN = [
        'image/jpeg',
        'image/png',
        'image/webp',
        'image/gif'
    ];
    private const MAKS_UKURAN_BYTES = 5 * 1024 * 1024; // 5 Megabytes

    /**
     * Memproses dan menyimpan berkas foto yang diunggah
     *
     * @param array $fileData Array berkas dari $_FILES['berkas']
     * @param string $subFolder Nama subfolder penyimpanan (default: 'produk')
     * @return array Daftar URL publik berkas yang berhasil diunggah
     * @throws \RuntimeException Jika berkas tidak valid atau gagal disimpan
     */
    public static function simpanBanyakFoto(array $fileData, string $subFolder = 'produk'): array
    {
        $berkasTersusun = self::susunUlangArrayFiles($fileData);
        if (empty($berkasTersusun)) {
            throw new \RuntimeException('Tidak ada berkas gambar yang dipilih.');
        }

        $direktoriRootBackend = dirname(__DIR__, 3);
        $direktoriTujuan = realpath($direktoriRootBackend . '/unggah') ?: ($direktoriRootBackend . '/unggah');
        if (!is_dir($direktoriTujuan . '/' . $subFolder)) {
            mkdir($direktoriTujuan . '/' . $subFolder, 0755, true);
        }

        $protokol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https://' : 'http://';
        $host = $_SERVER['HTTP_HOST'] ?? '127.0.0.1:8000';
        $baseUrl = $protokol . $host . '/unggah/' . $subFolder . '/';

        $hasilUrl = [];

        foreach ($berkasTersusun as $berkas) {
            if ($berkas['error'] !== UPLOAD_ERR_OK) {
                continue;
            }

            if ($berkas['size'] > self::MAKS_UKURAN_BYTES) {
                throw new \RuntimeException('Ukuran berkas "' . htmlspecialchars($berkas['name']) . '" melebihi batas 5MB.');
            }

            // Validasi MIME Type secara riil menggunakan finfo
            $finfo = new \finfo(FILEINFO_MIME_TYPE);
            $mimeNyata = $finfo->file($berkas['tmp_name']);

            if (!in_array($mimeNyata, self::MIME_DIIZINKAN, true)) {
                throw new \RuntimeException('Format berkas "' . htmlspecialchars($berkas['name']) . '" tidak didukung. Harap gunakan JPG, PNG, atau WEBP.');
            }

            $ekstensi = strtolower(pathinfo($berkas['name'], PATHINFO_EXTENSION));
            if (!in_array($ekstensi, self::EKSTENSI_DIIZINKAN, true)) {
                $ekstensi = 'jpg';
            }

            // Generate nama berkas unik dan terlindungi
            $namaBerkasBaru = 'wbf_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $ekstensi;
            $tujuanLengkap = $direktoriTujuan . '/' . $subFolder . '/' . $namaBerkasBaru;

            if (!move_uploaded_file($berkas['tmp_name'], $tujuanLengkap)) {
                throw new \RuntimeException('Gagal memindahkan berkas ke folder penyimpanan server.');
            }

            $hasilUrl[] = $baseUrl . $namaBerkasBaru;
        }

        if (empty($hasilUrl)) {
            throw new \RuntimeException('Tidak ada berkas valid yang berhasil diproses.');
        }

        return $hasilUrl;
    }

    /**
     * Menyusun ulang struktur array $_FILES multi-upload PHP agar mudah diiterasi
     */
    private static function susunUlangArrayFiles(array $filePost): array
    {
        $hasil = [];

        if (is_array($filePost['name'])) {
            $jumlahBerkas = count($filePost['name']);
            $kunci = array_keys($filePost);

            for ($i = 0; $i < $jumlahBerkas; $i++) {
                if (empty($filePost['name'][$i])) {
                    continue;
                }
                foreach ($kunci as $k) {
                    $hasil[$i][$k] = $filePost[$k][$i];
                }
            }
        } else if (!empty($filePost['name'])) {
            $hasil[] = $filePost;
        }

        return $hasil;
    }
}
