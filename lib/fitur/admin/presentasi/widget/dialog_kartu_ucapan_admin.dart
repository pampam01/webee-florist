import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/fitur/pesanan/data/model/pesanan_model.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class DialogKartuUcapanAdmin extends StatelessWidget {
  final PesananModel pesanan;

  const DialogKartuUcapanAdmin({
    super.key,
    required this.pesanan,
  });

  String _formatTeksWhatsApp() {
    final buffer = StringBuffer();
    buffer.writeln('*DISPOSISI PENGANTARAN BUNGA WEBEE FLORIST*');
    buffer.writeln('Nomor Pesanan: #${pesanan.nomorPesanan}');
    buffer.writeln('Jadwal Kirim: ${pesanan.tanggalKirim ?? '-'} (${pesanan.estimasiJamKirim ?? 'Reguler'})');
    buffer.writeln('Jenis Armada: ${_labelArmada(pesanan.jenisKurir)}');
    if (pesanan.namaKurir != null && pesanan.namaKurir!.isNotEmpty) {
      buffer.writeln('Nama Driver: ${pesanan.namaKurir}');
    }
    if (pesanan.nomorResi != null && pesanan.nomorResi!.isNotEmpty) {
      buffer.writeln('Nomor Resi / Armada: ${pesanan.nomorResi}');
    }
    buffer.writeln('');
    buffer.writeln('*DATA PENERIMA:*');
    buffer.writeln('Nama: ${pesanan.namaPenerima}');
    buffer.writeln('Telepon: ${pesanan.teleponPenerima}');
    buffer.writeln('Alamat: ${pesanan.alamatPengiriman}');
    buffer.writeln('');
    buffer.writeln('*RANGKAIAN BUNGA:*');
    if (pesanan.itemPesanan.isNotEmpty) {
      for (final item in pesanan.itemPesanan) {
        final nama = item.namaProdukSnapshot ?? item.produk?.nama ?? 'Buket Bunga';
        buffer.writeln('- $nama (${item.kuantitas} pcs)');
      }
    } else {
      buffer.writeln('- Rangkaian Pesanan #${pesanan.nomorPesanan}');
    }
    buffer.writeln('');
    buffer.writeln('*PESAN KARTU UCAPAN:*');
    buffer.writeln('"${pesanan.pesanKartuUcapan ?? '(Tanpa pesan kartu ucapan)'}"');
    buffer.writeln('');
    buffer.writeln('*CATATAN KHUSUS FLORIST:*');
    buffer.writeln('1. Wajib pastikan buket / vas bunga dalam posisi tegak.');
    buffer.writeln('2. Lindungi dari terik matahari langsung dan terpaan angin.');
    buffer.writeln('3. Harap serahkan dengan sopan dan foto bukti tanda terima.');

    return buffer.toString();
  }

  String _labelArmada(String? jenis) {
    switch (jenis) {
      case 'armada_mobil_berpendingin':
        return 'Armada Mobil Florist Berpendingin (Chilled Floral Van)';
      case 'kurir_motor_florist':
        return 'Kurir Motor Khusus Florist (Tas Bunga Anti-Angin)';
      case 'kurir_eksternal_instan':
        return 'Kurir Eksternal Instan (GrabExpress / GoSend)';
      default:
        return 'Kurir Standar Florist';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pesanUcapan = (pesanan.pesanKartuUcapan != null &&
            pesanan.pesanKartuUcapan!.trim().isNotEmpty)
        ? pesanan.pesanKartuUcapan!.trim()
        : 'Tidak ada permintaan pesan khusus pada kartu ucapan.';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Dialog
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
                            Icons.local_florist_outlined,
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
                                'Kartu Ucapan & Disposisi',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: WarnaAplikasi.teksUtama,
                                ),
                              ),
                              Text(
                                'Pesanan #${pesanan.nomorPesanan}',
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
              const SizedBox(height: 20),

              // Preview Kartu Kaligrafi Klasik
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDF9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: WarnaAplikasi.aksenEmas.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: WarnaAplikasi.aksenEmas.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 1,
                          color: WarnaAplikasi.aksenEmas,
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.auto_stories,
                          size: 16,
                          color: WarnaAplikasi.aksenEmas,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 32,
                          height: 1,
                          color: WarnaAplikasi.aksenEmas,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Pour: ${pesanan.namaPenerima}',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: WarnaAplikasi.utama,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '"$pesanUcapan"',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                        color: WarnaAplikasi.teksUtama,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          size: 12,
                          color: WarnaAplikasi.aksenMawar,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Webee Florist Artisan Signature Card',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 0.8,
                            color: WarnaAplikasi.teksSekunder.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Tombol Salin Pesan Kartu Ucapan
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: WarnaAplikasi.utama,
                  side: const BorderSide(color: WarnaAplikasi.utama),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: pesanUcapan));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pesan kartu ucapan berhasil disalin ke papan klip.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.copy, size: 16),
                label: const Text(
                  'Salin Teks Kartu Ucapan',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),

              const SizedBox(height: 20),
              const Divider(color: WarnaAplikasi.garisBatas),
              const SizedBox(height: 12),

              // Bagian Template WhatsApp Driver
              Row(
                children: [
                  const Icon(
                    Icons.directions_bike,
                    size: 18,
                    color: WarnaAplikasi.utama,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Disposisi Logistik untuk Driver / Kurir',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: WarnaAplikasi.teksUtama,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: WarnaAplikasi.latarBelakang,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: WarnaAplikasi.garisBatas),
                ),
                child: Text(
                  _formatTeksWhatsApp(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    height: 1.4,
                    color: WarnaAplikasi.teksUtama,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Tombol Aksi Salin Template WA
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: WarnaAplikasi.sukses,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final teksWA = _formatTeksWhatsApp();
                  Clipboard.setData(ClipboardData(text: teksWA));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Format disposisi WhatsApp kurir berhasil disalin.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.content_copy, size: 16),
                label: const Text(
                  'Salin Format Pesan WhatsApp Kurir',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
