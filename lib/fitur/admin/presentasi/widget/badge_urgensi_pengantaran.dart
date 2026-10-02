import 'package:flutter/material.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class BadgeUrgensiPengantaran extends StatelessWidget {
  final String? tanggalKirim;
  final String? estimasiJam;

  const BadgeUrgensiPengantaran({
    super.key,
    required this.tanggalKirim,
    this.estimasiJam,
  });

  @override
  Widget build(BuildContext context) {
    if (tanggalKirim == null || tanggalKirim!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    DateTime? tgl;
    try {
      tgl = DateTime.parse(tanggalKirim!.trim().split(' ').first);
    } catch (_) {
      return const SizedBox.shrink();
    }

    final sekarang = DateTime.now();
    final hariIni = DateTime(sekarang.year, sekarang.month, sekarang.day);
    final targetHari = DateTime(tgl.year, tgl.month, tgl.day);
    final selisihHari = targetHari.difference(hariIni).inDays;

    Color warnaLatar;
    Color warnaTeks;
    IconData ikon;
    String label;

    if (selisihHari == 0) {
      warnaLatar = WarnaAplikasi.bahaya.withValues(alpha: 0.12);
      warnaTeks = WarnaAplikasi.bahaya;
      ikon = Icons.access_time_filled;
      label = 'PENGANTARAN HARI INI';
    } else if (selisihHari == 1) {
      warnaLatar = WarnaAplikasi.peringatan.withValues(alpha: 0.15);
      warnaTeks = WarnaAplikasi.peringatan;
      ikon = Icons.calendar_today_outlined;
      label = 'PENGANTARAN BESOK';
    } else if (selisihHari > 1) {
      warnaLatar = WarnaAplikasi.sukses.withValues(alpha: 0.12);
      warnaTeks = WarnaAplikasi.sukses;
      ikon = Icons.event_available;
      label = 'MENDATANG ($selisihHari HARI)';
    } else {
      warnaLatar = WarnaAplikasi.teksRedup.withValues(alpha: 0.15);
      warnaTeks = WarnaAplikasi.teksSekunder;
      ikon = Icons.history;
      label = 'SELESAI / LEWAT JADWAL';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: warnaLatar,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: warnaTeks.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 12, color: warnaTeks),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: warnaTeks,
            ),
          ),
          if (estimasiJam != null && estimasiJam!.trim().isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(
              '($estimasiJam)',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: warnaTeks,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
