import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class SeksiUlasan extends StatelessWidget {
  const SeksiUlasan({super.key});

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
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Kisah & Ulasan Hangat Pelanggan',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: adalahDesktop ? 32 : 26,
                  fontWeight: FontWeight.w800,
                  color: WarnaAplikasi.teksUtama,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text(
                  'Kesan tulus dari para pelanggan yang mempercayakan ungkapan rasa dan kejutan terbaiknya kepada atelier kami.',
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
                      ? 3
                      : constraints.maxWidth >= 600
                          ? 2
                          : 1;

                  return GridView.count(
                    crossAxisCount: kolom,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: kolom == 1 ? 2.2 : 1.15,
                    children: const [
                      _KartuUlasan(
                        nama: 'Clara Anindya',
                        peristiwa: 'Ulang Tahun Pernikahan, Jakarta Selatan',
                        isiUlasan:
                            'Buket mawar merahnya sungguh memukau! Bunganya sangat segar dan wangi tahan hingga lima hari. Kartu ucapan tulisan tangannya begitu puitis dan personal.',
                      ),
                      _KartuUlasan(
                        nama: 'Daffa Wardhana',
                        peristiwa: 'Buket Wisuda Universitas Indonesia',
                        isiUlasan:
                            'Pengiriman sangat tepat waktu di lokasi wisuda. Rangkaian bunga matahari dan bonekanya rapi sekali, wrapping satinnya terasa eksklusif.',
                      ),
                      _KartuUlasan(
                        nama: 'Nathalia Kusuma',
                        peristiwa: 'Dekorasi Vas Meja Atelier, BSD City',
                        isiUlasan:
                            'Bunga Lily Casablanca dalam vas kacanya menjadi pusat perhatian di ruang tamu. Sangat puas dengan pelayanan ramah dan profesional dari Florist Utiy.',
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

class _KartuUlasan extends StatelessWidget {
  final String nama;
  final String peristiwa;
  final String isiUlasan;

  const _KartuUlasan({
    required this.nama,
    required this.peristiwa,
    required this.isiUlasan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: WarnaAplikasi.latarBelakang,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WarnaAplikasi.garisBatas),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bintang Rating Emas
              Row(
                children: List.generate(
                  5,
                  (index) => const Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: WarnaAplikasi.aksenEmas,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '"$isiUlasan"',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: WarnaAplikasi.teksUtama,
                  height: 1.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nama,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: WarnaAplikasi.utama,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                peristiwa,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: WarnaAplikasi.teksSekunder,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
