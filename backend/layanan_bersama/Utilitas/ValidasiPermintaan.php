<?php

namespace WebeeFlorist\Utilitas;

class ValidasiPermintaan
{
    private array $data;
    private array $daftarKesalahan = [];

    public function __construct(array $data)
    {
        $this->data = $data;
    }

    public static function buat(array $data): self
    {
        return new self($data);
    }

    public function validasi(array $aturan): bool
    {
        $this->daftarKesalahan = [];

        foreach ($aturan as $bidang => $definisiAturan) {
            $aturanList = explode('|', $definisiAturan);
            $nilai = $this->data[$bidang] ?? null;

            foreach ($aturanList as $item) {
                $parameter = null;
                if (str_contains($item, ':')) {
                    [$namaAturan, $parameter] = explode(':', $item, 2);
                } else {
                    $namaAturan = $item;
                }

                switch ($namaAturan) {
                    case 'wajib':
                        if ($nilai === null || trim((string)$nilai) === '') {
                            $this->tambahKesalahan($bidang, "Bidang {$bidang} wajib diisi.");
                        }
                        break;

                    case 'email':
                        if ($nilai !== null && $nilai !== '' && !filter_var($nilai, FILTER_VALIDATE_EMAIL)) {
                            $this->tambahKesalahan($bidang, "Format {$bidang} tidak valid.");
                        }
                        break;

                    case 'minimal':
                        $min = (int) $parameter;
                        if ($nilai !== null && strlen((string)$nilai) < $min) {
                            $this->tambahKesalahan($bidang, "Bidang {$bidang} minimal {$min} karakter.");
                        }
                        break;

                    case 'numerik':
                        if ($nilai !== null && $nilai !== '' && !is_numeric($nilai)) {
                            $this->tambahKesalahan($bidang, "Bidang {$bidang} harus berupa angka numerik.");
                        }
                        break;

                    case 'dalam':
                        $opsi = explode(',', (string)$parameter);
                        if ($nilai !== null && !in_array($nilai, $opsi, true)) {
                            $this->tambahKesalahan($bidang, "Nilai {$bidang} harus salah satu dari: " . implode(', ', $opsi) . ".");
                        }
                        break;
                }
            }
        }

        return empty($this->daftarKesalahan);
    }

    private function tambahKesalahan(string $bidang, string $pesan): void
    {
        if (!isset($this->daftarKesalahan[$bidang])) {
            $this->daftarKesalahan[$bidang] = [];
        }
        $this->daftarKesalahan[$bidang][] = $pesan;
    }

    public function ambilKesalahan(): array
    {
        return $this->daftarKesalahan;
    }

    public function lemparJikaGagal(): void
    {
        if (!empty($this->daftarKesalahan)) {
            TanggapanJson::gagal('Validasi formulir gagal', 422, $this->daftarKesalahan);
        }
    }
}
