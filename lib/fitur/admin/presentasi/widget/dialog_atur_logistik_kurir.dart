import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/fitur/pesanan/data/model/pesanan_model.dart';
import 'package:webee_florist/fitur/pesanan/presentasi/penyedia/penyedia_pesanan.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class DialogAturLogistikKurir extends ConsumerStatefulWidget {
  final PesananModel pesanan;
  final bool ubahStatusKeKirim;

  const DialogAturLogistikKurir({
    super.key,
    required this.pesanan,
    this.ubahStatusKeKirim = true,
  });

  @override
  ConsumerState<DialogAturLogistikKurir> createState() => _DialogAturLogistikKurirState();
}

class _DialogAturLogistikKurirState extends ConsumerState<DialogAturLogistikKurir> {
  late String _jenisKurirTerpilih;
  late TextEditingController _kontrolerNamaKurir;
  late TextEditingController _kontrolerTeleponKurir;
  late TextEditingController _kontrolerNomorResi;
  late TextEditingController _kontrolerEstimasiJam;
  final _kunciForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _jenisKurirTerpilih = widget.pesanan.jenisKurir ?? 'armada_mobil_berpendingin';
    _kontrolerNamaKurir = TextEditingController(text: widget.pesanan.namaKurir ?? '');
    _kontrolerTeleponKurir = TextEditingController(text: widget.pesanan.teleponKurir ?? '');
    _kontrolerNomorResi = TextEditingController(
      text: widget.pesanan.nomorResi ?? 'WBF-LOG-${DateTime.now().millisecondsSinceEpoch % 1000}',
    );
    _kontrolerEstimasiJam = TextEditingController(
      text: widget.pesanan.estimasiJamKirim ?? '13:00 - 15:00 WIB',
    );
  }

  @override
  void dispose() {
    _kontrolerNamaKurir.dispose();
    _kontrolerTeleponKurir.dispose();
    _kontrolerNomorResi.dispose();
    _kontrolerEstimasiJam.dispose();
    super.dispose();
  }

  Future<void> _simpanDanKirim() async {
    if (!_kunciForm.currentState!.validate()) return;

    final dataLogistik = {
      'jenis_kurir': _jenisKurirTerpilih,
      'nama_kurir': _kontrolerNamaKurir.text.trim(),
      'telepon_kurir': _kontrolerTeleponKurir.text.trim(),
      'nomor_resi': _kontrolerNomorResi.text.trim(),
      'estimasi_jam_kirim': _kontrolerEstimasiJam.text.trim(),
    };

    final statusBaru = widget.ubahStatusKeKirim ? 'dikirim' : widget.pesanan.status;

    final berhasil = await ref.read(aksiPesananAdminProvider.notifier).ubahStatusDanLogistik(
          pesananId: widget.pesanan.id,
          statusBaru: statusBaru,
          dataLogistik: dataLogistik,
        );

    if (!mounted) return;

    if (berhasil) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.ubahStatusKeKirim
                ? 'Pesanan #${widget.pesanan.nomorPesanan} berhasil diberangkatkan bersama kurir.'
                : 'Data logistik pesanan #${widget.pesanan.nomorPesanan} berhasil diperbarui.',
          ),
          backgroundColor: WarnaAplikasi.sukses,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memperbarui logistik kurir. Coba beberapa saat lagi.'),
          backgroundColor: WarnaAplikasi.bahaya,
        ),
      );
    }
  }

  Widget _buatOpsiArmada({
    required String nilai,
    required String judul,
    required String deskripsi,
    required IconData ikon,
  }) {
    final terpilih = _jenisKurirTerpilih == nilai;
    return InkWell(
      onTap: () => setState(() => _jenisKurirTerpilih = nilai),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: terpilih ? WarnaAplikasi.aksenMerahMuda.withValues(alpha: 0.5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: terpilih ? WarnaAplikasi.utama : WarnaAplikasi.garisBatas,
            width: terpilih ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: terpilih ? WarnaAplikasi.utama : WarnaAplikasi.latarBelakang,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                ikon,
                size: 20,
                color: terpilih ? Colors.white : WarnaAplikasi.utama,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: terpilih ? WarnaAplikasi.utama : WarnaAplikasi.teksUtama,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    deskripsi,
                    style: const TextStyle(
                      fontSize: 11,
                      color: WarnaAplikasi.teksSekunder,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: nilai,
              groupValue: _jenisKurirTerpilih,
              activeColor: WarnaAplikasi.utama,
              onChanged: (val) {
                if (val != null) setState(() => _jenisKurirTerpilih = val);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sedangProses = ref.watch(aksiPesananAdminProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _kunciForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: WarnaAplikasi.aksenMerahMuda,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.local_shipping_outlined,
                              color: WarnaAplikasi.utama,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Atur Logistik Pengiriman',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: WarnaAplikasi.teksUtama,
                                  ),
                                ),
                                Text(
                                  'Pesanan #${widget.pesanan.nomorPesanan} (${widget.pesanan.namaPenerima})',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: WarnaAplikasi.teksSekunder,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Pilihan Armada Khusus Florist
                const Text(
                  'Pilih Moda Armada Pengantaran',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: WarnaAplikasi.teksUtama,
                  ),
                ),
                const SizedBox(height: 10),
                _buatOpsiArmada(
                  nilai: 'armada_mobil_berpendingin',
                  judul: 'Armada Mobil Berpendingin (Chilled Van)',
                  deskripsi: 'Suhu sejuk stabil untuk vas kristal, standing flower, dan buket mawar luxury.',
                  ikon: Icons.ac_unit,
                ),
                const SizedBox(height: 8),
                _buatOpsiArmada(
                  nilai: 'kurir_motor_florist',
                  judul: 'Kurir Motor Khusus Florist',
                  deskripsi: 'Dilengkapi tas pelindung anti-angin dan gantungan buket tegak.',
                  ikon: Icons.two_wheeler,
                ),
                const SizedBox(height: 8),
                _buatOpsiArmada(
                  nilai: 'kurir_eksternal_instan',
                  judul: 'Kurir Eksternal Instan',
                  deskripsi: 'Pengiriman darurat cepat menggunakan GrabExpress atau GoSend.',
                  ikon: Icons.delivery_dining,
                ),
                const SizedBox(height: 18),

                // Form Input Detail Driver
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _kontrolerNamaKurir,
                        decoration: InputDecoration(
                          labelText: 'Nama Driver / Kurir',
                          hintText: 'Contoh: Budi Santoso',
                          prefixIcon: const Icon(Icons.person_outline, size: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Wajib diisi';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _kontrolerTeleponKurir,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'No. WhatsApp Kurir',
                          hintText: '0812xxxxxxx',
                          prefixIcon: const Icon(Icons.phone_outlined, size: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Wajib diisi';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _kontrolerNomorResi,
                        decoration: InputDecoration(
                          labelText: 'No. Resi / Plat Mobil',
                          hintText: 'Contoh: B 1234 WBF',
                          prefixIcon: const Icon(Icons.confirmation_number_outlined, size: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _kontrolerEstimasiJam,
                        decoration: InputDecoration(
                          labelText: 'Estimasi Jam Sampai',
                          hintText: '13:00 - 15:00 WIB',
                          prefixIcon: const Icon(Icons.access_time, size: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // Tombol Aksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: sedangProses ? null : () => Navigator.of(context).pop(),
                      child: const Text('Batal'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WarnaAplikasi.utama,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: sedangProses ? null : _simpanDanKirim,
                      icon: sedangProses
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_outlined, size: 16),
                      label: Text(
                        widget.ubahStatusKeKirim ? 'Berangkatkan Kurir' : 'Simpan Perubahan',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
