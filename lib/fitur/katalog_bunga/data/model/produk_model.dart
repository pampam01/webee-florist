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
  final bool apakahTersedia;
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
    this.apakahTersedia = true,
    this.kategori,
  });

  factory ProdukBungaModel.fromJson(Map<String, dynamic> json) {
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
      apakahTersedia: json['apakah_tersedia'] == true ||
          json['apakah_tersedia'] == 1 ||
          json['status_tersedia'] == true ||
          json['status_tersedia'] == 1,
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
      'apakah_tersedia': apakahTersedia,
      'kategori': kategori?.toJson(),
    };
  }
}
