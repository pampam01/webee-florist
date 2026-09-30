import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class KakiHalamanWeb extends StatelessWidget {
  final Function(int indeksSeksi)? padaPilihSeksi;

  const KakiHalamanWeb({super.key, this.padaPilihSeksi});

  @override
  Widget build(BuildContext context) {
    final lebarLayar = MediaQuery.of(context).size.width;
    final adalahDesktop = lebarLayar >= 960;

    return Container(
      width: double.infinity,
      color: WarnaAplikasi.utamaGelap,
      padding: EdgeInsets.symmetric(
        horizontal: adalahDesktop ? 64 : 24,
        vertical: 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Kolom Informasi Utama
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 960) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 4, child: _kolomIdentitas(context)),
                        const SizedBox(width: 48),
                        Expanded(flex: 2, child: _kolomKoleksi(context)),
                        const SizedBox(width: 32),
                        Expanded(flex: 3, child: _kolomLayanan(context)),
                        const SizedBox(width: 32),
                        Expanded(flex: 3, child: _kolomKontak(context)),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _kolomIdentitas(context),
                        const SizedBox(height: 32),
                        _kolomKoleksi(context),
                        const SizedBox(height: 28),
                        _kolomLayanan(context),
                        const SizedBox(height: 28),
                        _kolomKontak(context),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 48),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 24),

              // Baris Hak Cipta
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '© 2025 - 2026 Webee Florist by utiy. Seluruh Hak Cipta Dilindungi.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                  ),
                  Text(
                    'Artisan Botanical Florist',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kolomIdentitas(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            'assets/logo/logo_webee_horizontal.png',
            height: 36,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Text(
              'WEBEE Florist by utiy',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: WarnaAplikasi.utama,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Atelier bunga segar dengan kurasi seni klasik romantis Perancis. Menghadirkan gubahan mawar beludru impor, vas meja antik, dan karangan bunga terindah untuk menyempurnakan setiap perayaan rasa.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: Colors.white70,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _kolomKoleksi(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Koleksi Bunga',
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 14),
        _itemTautan('Buket Mawar Romantis', () => padaPilihSeksi?.call(1)),
        _itemTautan('Bunga Meja & Vas', () => padaPilihSeksi?.call(1)),
        _itemTautan('Buket Wisuda Ceria', () => padaPilihSeksi?.call(1)),
        _itemTautan('Bunga Papan Kehormatan', () => padaPilihSeksi?.call(1)),
      ],
    );
  }

  Widget _kolomLayanan(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layanan Kami',
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 14),
        _itemTautan('Pengiriman Hari Sama (Same-Day)', null),
        _itemTautan('Kartu Kaligrafi Tulis Tangan', null),
        _itemTautan('Pemesanan Kustom Acara', null),
        _itemTautan('Panduan Perawatan Bunga', null),
      ],
    );
  }

  Widget _kolomKontak(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Studio Atelier',
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on_outlined, size: 16, color: Colors.white70),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Jl. Senopati No. 45, Kebayoran Baru, Jakarta Selatan',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white70, height: 1.4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.white70),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Setiap Hari: 08.00 - 21.00 WIB',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white70),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.white70),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'WhatsApp: +62 812-9876-5432',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white70),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _itemTautan(String teks, VoidCallback? padaTekan) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: padaTekan,
        child: Text(
          teks,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: Colors.white70,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
