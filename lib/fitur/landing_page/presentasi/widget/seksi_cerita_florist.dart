import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class SeksiCeritaFlorist extends StatelessWidget {
  const SeksiCeritaFlorist({super.key});

  @override
  Widget build(BuildContext context) {
    final lebarLayar = MediaQuery.of(context).size.width;
    final adalahDesktop = lebarLayar >= 960;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: adalahDesktop ? 64 : 24,
        vertical: 60,
      ),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: adalahDesktop ? _tataLetakDesktop(context) : _tataLetakMobile(context),
        ),
      ),
    );
  }

  Widget _tataLetakDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Sisi Kiri: Logo Lencana Persegi Webee
        Expanded(
          flex: 8,
          child: _bingkaiLogoLencana(),
        ),
        const SizedBox(width: 56),

        // Sisi Kanan: Narasi Kisah & Filosofi
        Expanded(
          flex: 12,
          child: _kontenCerita(context),
        ),
      ],
    );
  }

  Widget _tataLetakMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _bingkaiLogoLencana(),
        const SizedBox(height: 36),
        _kontenCerita(context, rataTengah: true),
      ],
    );
  }

  Widget _bingkaiLogoLencana() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360, maxHeight: 360),
        decoration: BoxDecoration(
          color: WarnaAplikasi.latarBelakang,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: WarnaAplikasi.garisBatas, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: WarnaAplikasi.utama.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Image.asset(
          'assets/logo/logo_webee_persegi.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Center(
            child: Icon(Icons.local_florist, size: 72, color: WarnaAplikasi.utama),
          ),
        ),
      ),
    );
  }

  Widget _kontenCerita(BuildContext context, {bool rataTengah = false}) {
    return Column(
      crossAxisAlignment:
          rataTengah ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'FILOSOFI ATELIER KAMI',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: WarnaAplikasi.aksenEmas,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Seni Merangkai Kisah Romantis Abadi',
          textAlign: rataTengah ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.playfairDisplay(
            fontSize: rataTengah ? 26 : 34,
            fontWeight: FontWeight.w800,
            color: WarnaAplikasi.teksUtama,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Terinspirasi oleh keindahan toko bunga klasik di sudut jalanan Paris abad pertengahan, Webee Florist didirikan oleh Florist Utiy pada tahun 2025 dengan sebuah keyakinan sederhana: bunga bukanlah sekadar komoditas, melainkan bahasa rasa yang melampaui kata-kata.',
          textAlign: rataTengah ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: WarnaAplikasi.teksSekunder,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Nama "Webee" melambangkan kesetiaan lebah yang tekun menjelajahi padang bunga untuk menemukan sari nektar termurni. Semangat itulah yang mendasari dedikasi kami dalam mengurasi setiap kelopak, mengikat pita satin sutra, dan menuliskan pesan kaligrafi personal yang mengabadikan getaran cinta Anda.',
          textAlign: rataTengah ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: WarnaAplikasi.teksSekunder,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment:
              rataTengah ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: WarnaAplikasi.latarBelakang,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: WarnaAplikasi.garisBatas),
              ),
              child: Text(
                'Handcrafted with Love by Utiy',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: WarnaAplikasi.utama,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
