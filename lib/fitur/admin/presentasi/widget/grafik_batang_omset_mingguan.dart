import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';
import 'package:webee_florist/inti/utilitas/format_rupiah.dart';

class DataHariOmset {
  final String hari;
  final String tanggal;
  final double nominal;
  final bool puncak;

  const DataHariOmset({
    required this.hari,
    required this.tanggal,
    required this.nominal,
    this.puncak = false,
  });
}

class GrafikBatangOmsetMingguan extends StatefulWidget {
  const GrafikBatangOmsetMingguan({super.key});

  @override
  State<GrafikBatangOmsetMingguan> createState() => _GrafikBatangOmsetMingguanState();
}

class _GrafikBatangOmsetMingguanState extends State<GrafikBatangOmsetMingguan> {
  int? _indeksSorot;

  static const List<DataHariOmset> _dataMingguan = [
    DataHariOmset(hari: 'Sen', tanggal: '26 Sep', nominal: 1850000),
    DataHariOmset(hari: 'Sel', tanggal: '27 Sep', nominal: 2400000),
    DataHariOmset(hari: 'Rab', tanggal: '28 Sep', nominal: 1950000),
    DataHariOmset(hari: 'Kam', tanggal: '29 Sep', nominal: 3100000),
    DataHariOmset(hari: 'Jum', tanggal: '30 Sep', nominal: 4200000),
    DataHariOmset(hari: 'Sab', tanggal: '01 Okt', nominal: 4850000, puncak: true),
    DataHariOmset(hari: 'Min', tanggal: '02 Okt', nominal: 3650000),
  ];

  static const double _targetHarian = 2500000;

  @override
  Widget build(BuildContext context) {
    const double maksNominal = 5500000;
    final totalMingguIni = _dataMingguan.fold<double>(0, (sum, d) => sum + d.nominal);

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
          // Header Chart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: WarnaAplikasi.aksenMerahMuda,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.bar_chart_rounded,
                            size: 18,
                            color: WarnaAplikasi.utama,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tren Omset 7 Hari Terakhir',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: WarnaAplikasi.teksUtama,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total pekan ini: ${FormatRupiah.format(totalMingguIni)} • Rata-rata harian ${FormatRupiah.format(totalMingguIni / 7)}',
                      style: const TextStyle(fontSize: 11, color: WarnaAplikasi.teksSekunder),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: WarnaAplikasi.aksenEmas.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: WarnaAplikasi.aksenEmas.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_outline, size: 12, color: WarnaAplikasi.aksenEmas),
                    const SizedBox(width: 4),
                    Text(
                      'Puncak: Sabtu (Wisuda & Pesta)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: WarnaAplikasi.aksenEmas,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Area Batang Grafik
          SizedBox(
            height: 220,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final lebarTersedia = constraints.maxWidth;
                final lebarBatang = (lebarTersedia / _dataMingguan.length) * 0.52;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _dataMingguan.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    final tinggiRelatif = (data.nominal / maksNominal) * 130;
                    final isHover = _indeksSorot == index;

                    return MouseRegion(
                      onEnter: (_) => setState(() => _indeksSorot = index),
                      onExit: (_) => setState(() => _indeksSorot = null),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Tooltip Nominal Saat Disorot
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: (isHover || data.puncak) ? 1.0 : 0.0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: BoxDecoration(
                                color: data.puncak ? WarnaAplikasi.utama : WarnaAplikasi.teksUtama,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${(data.nominal / 1000000).toStringAsFixed(1)}jt',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          // Batang Silinder Bergaya Artisan
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: lebarBatang.clamp(24.0, 52.0),
                            height: tinggiRelatif.clamp(20.0, 130.0),
                            decoration: BoxDecoration(
                              gradient: data.puncak
                                  ? WarnaAplikasi.gradienEmas
                                  : LinearGradient(
                                      colors: isHover
                                          ? [WarnaAplikasi.utamaTerang, WarnaAplikasi.aksenMawar]
                                          : [WarnaAplikasi.utama, WarnaAplikasi.utamaTerang],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                              boxShadow: isHover || data.puncak
                                  ? [
                                      BoxShadow(
                                        color: data.puncak
                                            ? WarnaAplikasi.aksenEmas.withValues(alpha: 0.4)
                                            : WarnaAplikasi.utama.withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Label Hari & Tanggal
                          Text(
                            data.hari,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: data.puncak ? FontWeight.bold : FontWeight.w600,
                              color: data.puncak ? WarnaAplikasi.utama : WarnaAplikasi.teksUtama,
                            ),
                          ),
                          Text(
                            data.tanggal,
                            style: const TextStyle(fontSize: 9, color: WarnaAplikasi.teksSekunder),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 14),

          // Keterangan Garis Target & Indikator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: WarnaAplikasi.aksenEmas,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('Hari Puncak Penjualan', style: TextStyle(fontSize: 10, color: WarnaAplikasi.teksSekunder)),
                  const SizedBox(width: 16),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: WarnaAplikasi.utama,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('Penjualan Reguler', style: TextStyle(fontSize: 10, color: WarnaAplikasi.teksSekunder)),
                ],
              ),
              Text(
                'Target Harian: ${FormatRupiah.format(_targetHarian)}',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: WarnaAplikasi.sukses),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
