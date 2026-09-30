import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class SeksiHero extends StatelessWidget {
  final VoidCallback padaJelajahiKatalog;
  final VoidCallback padaHubungiWhatsapp;

  const SeksiHero({
    super.key,
    required this.padaJelajahiKatalog,
    required this.padaHubungiWhatsapp,
  });

  @override
  Widget build(BuildContext context) {
    final lebarLayar = MediaQuery.of(context).size.width;
    final adalahDesktop = lebarLayar >= 960;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: adalahDesktop ? 64 : 24,
        vertical: adalahDesktop ? 64 : 36,
      ),
      decoration: const BoxDecoration(
        color: WarnaAplikasi.latarBelakang,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: adalahDesktop ? _tataLetakDesktop(context) : _tataLetakMobile(context),
        ),
      ),
    );
  }

  Widget _tataLetakDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Sisi Kiri: Deskripsi & Ajakan Bertindak
        Expanded(
          flex: 11,
          child: _kontenTeksHero(context),
        ),
        const SizedBox(width: 48),

        // Sisi Kanan: Bingkai Lengkung Klasik (Archway) Bunga
        Expanded(
          flex: 9,
          child: _bingkaiArchHero(),
        ),
      ],
    );
  }

  Widget _tataLetakMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _kontenTeksHero(context, rataTengah: true),
        const SizedBox(height: 36),
        _bingkaiArchHero(),
      ],
    );
  }

  Widget _kontenTeksHero(BuildContext context, {bool rataTengah = false}) {
    return Column(
      crossAxisAlignment:
          rataTengah ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Lencana Estetika Atelier
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: WarnaAplikasi.utama.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: WarnaAplikasi.utama.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.spa_outlined, size: 14, color: WarnaAplikasi.utama),
              const SizedBox(width: 6),
              Text(
                'SINCE 2025 • ARTISAN BOTANICAL FLORISTRY',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: WarnaAplikasi.utama,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Judul Utama (SEO H1)
        Text(
          "L'Art des Fleurs — Keindahan Rangkaian Bunga Klasik Romantis",
          textAlign: rataTengah ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.playfairDisplay(
            fontSize: rataTengah ? 30 : 44,
            fontWeight: FontWeight.w800,
            color: WarnaAplikasi.teksUtama,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),

        // Subjudul Puitis & Deskriptif
        Text(
          'Setiap tangkai bunga dipilih dan dirangkai dengan dedikasi seni artisan oleh Florist Utiy untuk momen paling berharga dalam hidup Anda. Kesegaran alami bunga impor berpadu kemasan satin eksklusif dan kartu ucapan kaligrafi personal.',
          textAlign: rataTengah ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            color: WarnaAplikasi.teksSekunder,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 28),

        // Tombol Ajakan Bertindak
        Wrap(
          alignment: rataTengah ? WrapAlignment.center : WrapAlignment.start,
          spacing: 14,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: padaJelajahiKatalog,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Jelajahi Koleksi Bunga', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_downward, size: 16),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: padaHubungiWhatsapp,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 16),
                  SizedBox(width: 8),
                  Text('Konsultasi Pesanan Khusus'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),

        // Nilai Tambah / Trust Indicators (Tanpa Emoji)
        Wrap(
          alignment: rataTengah ? WrapAlignment.center : WrapAlignment.start,
          spacing: 24,
          runSpacing: 14,
          children: [
            _itemKepercayaan(Icons.verified_outlined, 'Bunga Impor Grade A'),
            _itemKepercayaan(Icons.edit_note_outlined, 'Kartu Kaligrafi Tulis Tangan'),
            _itemKepercayaan(Icons.local_shipping_outlined, 'Pengiriman Aman Berpendingin'),
          ],
        ),
      ],
    );
  }

  Widget _itemKepercayaan(IconData ikon, String judul) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(ikon, size: 16, color: WarnaAplikasi.utama),
        const SizedBox(width: 8),
        Text(
          judul,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: WarnaAplikasi.teksUtama,
          ),
        ),
      ],
    );
  }

  Widget _bingkaiArchHero() {
    return Center(
      child: Container(
        width: 380,
        height: 480,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(190),
            bottom: Radius.circular(16),
          ),
          border: Border.all(color: WarnaAplikasi.garisBatas, width: 2),
          boxShadow: [
            BoxShadow(
              color: WarnaAplikasi.utama.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(180),
              bottom: Radius.circular(12),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1561181286-d3fee7d55364?auto=format&fit=crop&w=800&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: WarnaAplikasi.latarBelakang,
                    child: const Center(
                      child: Icon(Icons.local_florist, size: 72, color: WarnaAplikasi.utama),
                    ),
                  ),
                ),
                // Lencana Estetika di bagian bawah bingkai
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: WarnaAplikasi.garisBatas),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Gubahan Unggulan Pekan Ini',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: WarnaAplikasi.teksSekunder,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'Red Velvet Rose Symphony',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: WarnaAplikasi.teksUtama,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: WarnaAplikasi.aksenEmas.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Koleksi Khusus',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: WarnaAplikasi.utama,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
