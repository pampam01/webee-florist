import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class TemaAplikasi {
  TemaAplikasi._();

  static ThemeData get temaTerang {
    final skemaWarna = ColorScheme.fromSeed(
      seedColor: WarnaAplikasi.utama,
      primary: WarnaAplikasi.utama,
      secondary: WarnaAplikasi.aksenMawar,
      tertiary: WarnaAplikasi.aksenEmas,
      surface: WarnaAplikasi.kartu,
      brightness: Brightness.light,
    );

    // Tipografi Berkelas: Playfair Display untuk Tajuk Klasik Romantis, Plus Jakarta Sans untuk Teks Bacaan
    final basisTeks = GoogleFonts.plusJakartaSansTextTheme().copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        color: WarnaAplikasi.teksUtama,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        color: WarnaAplikasi.teksUtama,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        color: WarnaAplikasi.teksUtama,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        color: WarnaAplikasi.teksUtama,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        color: WarnaAplikasi.teksUtama,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        color: WarnaAplikasi.teksUtama,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        color: WarnaAplikasi.teksUtama,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        color: WarnaAplikasi.teksUtama,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        color: WarnaAplikasi.teksUtama,
        fontSize: 16,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        color: WarnaAplikasi.teksSekunder,
        fontSize: 14,
        height: 1.5,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: skemaWarna,
      scaffoldBackgroundColor: WarnaAplikasi.latarBelakang,
      textTheme: basisTeks,
      appBarTheme: AppBarTheme(
        backgroundColor: WarnaAplikasi.latarBelakang,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: WarnaAplikasi.teksUtama,
        ),
        iconTheme: const IconThemeData(color: WarnaAplikasi.teksUtama),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: WarnaAplikasi.garisBatas, width: 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: WarnaAplikasi.utama,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: WarnaAplikasi.utama,
          side: const BorderSide(color: WarnaAplikasi.utama, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: WarnaAplikasi.garisBatas),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: WarnaAplikasi.garisBatas),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: WarnaAplikasi.utama, width: 1.5),
        ),
      ),
    );
  }
}
