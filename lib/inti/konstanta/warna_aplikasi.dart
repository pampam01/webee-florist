import 'package:flutter/material.dart';

class WarnaAplikasi {
  WarnaAplikasi._();

  // Warna Utama dari Logo Webee (French Chestnut & Warm Earth)
  static const Color utama = Color(0xFF6B4435);
  static const Color utamaTerang = Color(0xFF8B5E4D);
  static const Color utamaGelap = Color(0xFF4A2B20);

  // Aksen Romantis Klasik Perancis
  static const Color aksenMawar = Color(0xFFC87D75);
  static const Color aksenMerahMuda = Color(0xFFF3E5E3);
  static const Color aksenEmas = Color(0xFFC59B27);

  // Latar Belakang Hangat Kanvas Botani (Bukan Putih Polos)
  static const Color latarBelakang = Color(0xFFFAF7F2);
  static const Color kartu = Colors.white;
  static const Color garisBatas = Color(0xFFE8DED6);

  // Tipografi Tulisan Tangan & Teks Klasik
  static const Color teksUtama = Color(0xFF2D1F1B);
  static const Color teksSekunder = Color(0xFF7D6B64);
  static const Color teksRedup = Color(0xFFAFA39C);

  // Status Indikator
  static const Color sukses = Color(0xFF4A7C59);
  static const Color peringatan = Color(0xFFD48B38);
  static const Color bahaya = Color(0xFFB84A39);
  static const Color info = Color(0xFF5D7A88);

  // Gradien Mewah Parisian Florist
  static const LinearGradient gradienUtama = LinearGradient(
    colors: [Color(0xFF6B4435), Color(0xFF8B5E4D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradienEmas = LinearGradient(
    colors: [Color(0xFFE2C46D), Color(0xFFC59B27)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradienRomantis = LinearGradient(
    colors: [Color(0xFFFAF7F2), Color(0xFFF3ECE4)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
