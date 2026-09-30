import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class SeksiKeunggulan extends StatelessWidget {
  const SeksiKeunggulan({super.key});

  @override
  Widget build(BuildContext context) {
    final lebarLayar = MediaQuery.of(context).size.width;
    final adalahDesktop = lebarLayar >= 960;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: adalahDesktop ? 64 : 24,
        vertical: 54,
      ),
      color: WarnaAplikasi.latarBelakang,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Keunggulan Layanan Florist Kami',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: adalahDesktop ? 32 : 26,
                  fontWeight: FontWeight.w800,
                  color: WarnaAplikasi.teksUtama,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Text(
                  'Standar ketat yang menjaga kesempurnaan setiap gubahan bunga dari atelier kami hingga sampai ke pelukan penerima.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: WarnaAplikasi.teksSekunder,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              LayoutBuilder(
                builder: (context, constraints) {
                  final kolom = constraints.maxWidth >= 960
                      ? 4
                      : constraints.maxWidth >= 540
                          ? 2
                          : 1;

                  return GridView.count(
                    crossAxisCount: kolom,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: kolom == 1 ? 2.4 : (kolom == 2 ? 1.3 : 0.86),
                    children: const [
                      _KartuKeunggulan(
                        ikon: Icons.spa_outlined,
                        judul: 'Bunga Segar Pilihan Subuh',
                        deskripsi: 'Setiap kuntum diseleksi ketat di subuh hari guna menjamin kesegaran yang bertahan lama.',
                      ),
                      _KartuKeunggulan(
                        ikon: Icons.edit_note_outlined,
                        judul: 'Kartu Kaligrafi Tulisan Tangan',
                        deskripsi: 'Pesan personal Anda ditulis tangan menggunakan pena tinta elegan berbalut amplop lilin segel.',
                      ),
                      _KartuKeunggulan(
                        ikon: Icons.card_giftcard_outlined,
                        judul: 'Kemasan Satin & Beludru',
                        deskripsi: 'Material pembungkus kedap air dengan sentuhan pita satin sutra yang mempertegas kesan mewah.',
                      ),
                      _KartuKeunggulan(
                        ikon: Icons.local_shipping_outlined,
                        judul: 'Pengantaran Khusus Florist',
                        deskripsi: 'Armada pengantar terlatih menjaga posisi buket tetap tegak dan terlindung dari terik cuaca.',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KartuKeunggulan extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String deskripsi;

  const _KartuKeunggulan({
    required this.ikon,
    required this.judul,
    required this.deskripsi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WarnaAplikasi.garisBatas),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: WarnaAplikasi.utama.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(ikon, size: 22, color: WarnaAplikasi.utama),
          ),
          const SizedBox(height: 14),
          Text(
            judul,
            style: GoogleFonts.playfairDisplay(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: WarnaAplikasi.teksUtama,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            deskripsi,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: WarnaAplikasi.teksSekunder,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
