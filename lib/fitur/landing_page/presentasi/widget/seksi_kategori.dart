import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class SeksiKategori extends StatelessWidget {
  final Function(int idKategori)? padaPilihKategori;

  const SeksiKategori({super.key, this.padaPilihKategori});

  @override
  Widget build(BuildContext context) {
    final lebarLayar = MediaQuery.of(context).size.width;
    final adalahDesktop = lebarLayar >= 960;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: adalahDesktop ? 64 : 24,
        vertical: 48,
      ),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Header Seksi (SEO H2)
              Text(
                'Koleksi Rangkaian Bunga',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: adalahDesktop ? 32 : 26,
                  fontWeight: FontWeight.w800,
                  color: WarnaAplikasi.teksUtama,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Text(
                  'Setiap kategori dirancang dengan filosofi seni botani klasik untuk mewakili ungkapan kasih sayang, rasa syukur, dan penghormatan tulus.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: WarnaAplikasi.teksSekunder,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Grid 4 Kategori Pilihan
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
                    childAspectRatio: kolom == 1 ? 2.6 : 1.05,
                    children: [
                      _kartuKategori(
                        judul: 'Buket Mawar Romantis',
                        deskripsi: 'Mawar beludru impor grade A berbalut pita satin sutra.',
                        ikon: Icons.spa_outlined,
                        padaTekan: () => padaPilihKategori?.call(1),
                      ),
                      _kartuKategori(
                        judul: 'Bunga Meja & Vas',
                        deskripsi: 'Rangkaian vas kaca kristal untuk dekorasi ruang elegan.',
                        ikon: Icons.yard_outlined,
                        padaTekan: () => padaPilihKategori?.call(2),
                      ),
                      _kartuKategori(
                        judul: 'Buket Kelulusan',
                        deskripsi: 'Kombinasi ceria bunga matahari dan pastel untuk wisuda.',
                        ikon: Icons.school_outlined,
                        padaTekan: () => padaPilihKategori?.call(3),
                      ),
                      _kartuKategori(
                        judul: 'Bunga Papan Kehormatan',
                        deskripsi: 'Papan bunga megah untuk ucapan peresmian dan perhelatan.',
                        ikon: Icons.celebration_outlined,
                        padaTekan: () => padaPilihKategori?.call(4),
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

  Widget _kartuKategori({
    required String judul,
    required String deskripsi,
    required IconData ikon,
    required VoidCallback padaTekan,
  }) {
    return InkWell(
      onTap: padaTekan,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: WarnaAplikasi.latarBelakang,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WarnaAplikasi.garisBatas),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: WarnaAplikasi.garisBatas),
              ),
              child: Icon(ikon, size: 22, color: WarnaAplikasi.utama),
            ),
            const SizedBox(height: 14),
            Text(
              judul,
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
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
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
