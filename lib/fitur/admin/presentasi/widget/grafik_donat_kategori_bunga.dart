import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';
import 'package:webee_florist/inti/utilitas/format_rupiah.dart';

class ItemKategoriPenjualan {
  final String nama;
  final double porsiPersen;
  final double nominal;
  final int jumlahTerjual;
  final Color warna;

  const ItemKategoriPenjualan({
    required this.nama,
    required this.porsiPersen,
    required this.nominal,
    required this.jumlahTerjual,
    required this.warna,
  });
}

class GrafikDonatKategoriBunga extends StatelessWidget {
  const GrafikDonatKategoriBunga({super.key});

  static const List<ItemKategoriPenjualan> _dataKategori = [
    ItemKategoriPenjualan(
      nama: 'Buket Mawar Merah Provence',
      porsiPersen: 42,
      nominal: 7875000,
      jumlahTerjual: 37,
      warna: WarnaAplikasi.utama,
    ),
    ItemKategoriPenjualan(
      nama: 'Vas Kristal Anggrek Bulan',
      porsiPersen: 28,
      nominal: 5250000,
      jumlahTerjual: 25,
      warna: WarnaAplikasi.aksenEmas,
    ),
    ItemKategoriPenjualan(
      nama: 'Buket Lavender & Lily Parisien',
      porsiPersen: 18,
      nominal: 3375000,
      jumlahTerjual: 16,
      warna: WarnaAplikasi.aksenMawar,
    ),
    ItemKategoriPenjualan(
      nama: 'Sunflower Sunburst & Standing',
      porsiPersen: 12,
      nominal: 2250000,
      jumlahTerjual: 10,
      warna: WarnaAplikasi.info,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const int totalBuket = 88;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WarnaAplikasi.garisBatas),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: WarnaAplikasi.aksenMerahMuda,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.pie_chart_outline_rounded,
                  size: 18,
                  color: WarnaAplikasi.utama,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Distribusi Koleksi Terlaris',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: WarnaAplikasi.teksUtama,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Komposisi volume pesanan berdasarkan varian bunga favorit pelanggan.',
            style: TextStyle(fontSize: 11, color: WarnaAplikasi.teksSekunder),
          ),
          const SizedBox(height: 20),

          // Area Donut & Legend
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Lingkaran Donat Custom Painter
              SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(140, 140),
                      painter: _PelukisDonatKategori(_dataKategori),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$totalBuket',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: WarnaAplikasi.utama,
                          ),
                        ),
                        const Text(
                          'Buket Terjual',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: WarnaAplikasi.teksSekunder,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),

              // Rincian Daftar Kategori
              Expanded(
                child: Column(
                  children: _dataKategori.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: item.warna,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.nama,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: WarnaAplikasi.teksUtama,
                                  ),
                                ),
                                Text(
                                  '${item.jumlahTerjual} pesanan • ${FormatRupiah.format(item.nominal)}',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: WarnaAplikasi.teksSekunder,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: item.warna.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${item.porsiPersen.toInt()}%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: item.warna,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PelukisDonatKategori extends CustomPainter {
  final List<ItemKategoriPenjualan> daftar;

  _PelukisDonatKategori(this.daftar);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 10;
    const strokeWidth = 16.0;

    double startAngle = -math.pi / 2;

    for (final item in daftar) {
      final sweepAngle = (item.porsiPersen / 100) * 2 * math.pi;

      final paint = Paint()
        ..color = item.warna
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Beri sedikit celah antar segmen
      const gap = 0.04;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + gap,
        sweepAngle - (gap * 2),
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
