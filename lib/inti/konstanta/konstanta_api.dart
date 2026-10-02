import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class KonstantaApi {
  KonstantaApi._();

  static String get urlDasar {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api/v1';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8000/api/v1';
      }
    } catch (_) {}
    return 'http://127.0.0.1:8000/api/v1';
  }

  static const int waktuTenggangKoneksiMs = 15000;
  static const int waktuTenggangTerimaMs = 15000;

  static const String masuk = '/autentikasi/masuk';
  static const String daftar = '/autentikasi/daftar';
  static const String profil = '/autentikasi/profil';

  static const String kategori = '/katalog/kategori';
  static const String produk = '/katalog/produk';

  static const String keranjang = '/keranjang';
  static const String bersihkanKeranjang = '/keranjang/bersihkan';

  static const String pesanan = '/pesanan';
  static const String riwayatPesanan = '/pesanan/riwayat';

  static const String instruksiPembayaran = '/pembayaran/instruksi';
  static const String konfirmasiPembayaran = '/pembayaran/konfirmasi';

  static const String adminDashboard = '/admin/dashboard';
  static const String adminPesanan = '/pesanan/admin/semua';
  static const String adminProduk = '/katalog/admin/produk';
  static const String unggahFoto = '/katalog/unggah';

  static String formatUrlGambar(String? url) {
    if (url == null || url.trim().isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    final hostDasar = urlDasar.replaceAll('/api/v1', '');
    if (url.startsWith('/')) {
      return '$hostDasar$url';
    }
    return '$hostDasar/$url';
  }
}
