import 'dart:convert';
import 'kategori_model.dart';

class ProdukBungaModel {
  final int id;
  final int kategoriId;
  final String nama;
  final String slug;
  final String deskripsi;
  final double harga;
  final int stok;
  final String? urlGambar;
  final List<String> galeriFoto;
  final bool apakahTersedia;
  final bool apakahUnggulan;
  final KategoriModel? kategori;

  const ProdukBungaModel({
    required this.id,
    required this.kategoriId,
    required this.nama,
    required this.slug,
    required this.deskripsi,
    required this.harga,
    required this.stok,
    this.urlGambar,
    this.galeriFoto = const [],
    this.apakahTersedia = true,
    this.apakahUnggulan = false,
    this.kategori,
  });

  /// Mengembalikan seluruh foto produk (foto sampul utama + foto-foto galeri)
  List<String> get semuaFoto {
    final list = <String>[];
    if (urlGambar != null && urlGambar!.trim().isNotEmpty) {
      list.add(urlGambar!);
    }
    for (final f in galeriFoto) {
      if (f.trim().isNotEmpty && !list.contains(f)) {
        list.add(f);
      }
    }
    return list;
  }

  factory ProdukBungaModel.fromJson(Map<String, dynamic> json) {
    List<String> galeri = [];
    if (json['foto_galeri'] != null) {
      if (json['foto_galeri'] is List) {
        galeri = (json['foto_galeri'] as List).map((e) => e.toString()).toList();
      } else if (json['foto_galeri'] is String && json['foto_galeri'].toString().isNotEmpty) {
        try {
          final decoded = jsonDecode(json['foto_galeri']);
          if (decoded is List) {
            galeri = decoded.map((e) => e.toString()).toList();
          }
        } catch (_) {
          galeri = [json['foto_galeri'].toString()];
        }
      }
    }

    return ProdukBungaModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      kategoriId: json['kategori_id'] is int
          ? json['kategori_id']
          : json['id_kategori'] is int
              ? json['id_kategori']
              : int.tryParse(json['kategori_id']?.toString() ?? json['id_kategori']?.toString() ?? '0') ?? 0,
      nama: json['nama'] ?? json['nama_bunga'] ?? '',
      slug: json['slug'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      harga: json['harga'] != null ? double.tryParse(json['harga'].toString()) ?? 0.0 : 0.0,
      stok: json['stok'] is int ? json['stok'] : int.tryParse(json['stok'].toString()) ?? 0,
      urlGambar: json['url_gambar'] ?? json['gambar_url'],
      galeriFoto: galeri,
      apakahTersedia: json['apakah_tersedia'] == true ||
          json['apakah_tersedia'] == 1 ||
          json['status_tersedia'] == true ||
          json['status_tersedia'] == 1,
      apakahUnggulan: json['apakah_unggulan'] == true || json['apakah_unggulan'] == 1,
      kategori: json['kategori'] != null && json['kategori'] is Map<String, dynamic>
          ? KategoriModel.fromJson(json['kategori'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategori_id': kategoriId,
      'nama': nama,
      'slug': slug,
      'deskripsi': deskripsi,
      'harga': harga,
      'stok': stok,
      'url_gambar': urlGambar,
      'foto_galeri': galeriFoto,
      'apakah_tersedia': apakahTersedia,
      'apakah_unggulan': apakahUnggulan,
      'kategori': kategori?.toJson(),
    };
  }

  ProdukBungaModel copyWith({
    int? id,
    int? kategoriId,
    String? nama,
    String? slug,
    String? deskripsi,
    double? harga,
    int? stok,
    String? urlGambar,
    List<String>? galeriFoto,
    bool? apakahTersedia,
    bool? apakahUnggulan,
    KategoriModel? kategori,
  }) {
    return ProdukBungaModel(
      id: id ?? this.id,
      kategoriId: kategoriId ?? this.kategoriId,
      nama: nama ?? this.nama,
      slug: slug ?? this.slug,
      deskripsi: deskripsi ?? this.deskripsi,
      harga: harga ?? this.harga,
      stok: stok ?? this.stok,
      urlGambar: urlGambar ?? this.urlGambar,
      galeriFoto: galeriFoto ?? this.galeriFoto,
      apakahTersedia: apakahTersedia ?? this.apakahTersedia,
      apakahUnggulan: apakahUnggulan ?? this.apakahUnggulan,
      kategori: kategori ?? this.kategori,
    );
  }
}
