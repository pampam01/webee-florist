class KategoriModel {
  final int id;
  final String nama;
  final String slug;
  final String? deskripsi;
  final String? ikon;

  const KategoriModel({
    required this.id,
    required this.nama,
    required this.slug,
    this.deskripsi,
    this.ikon,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      nama: json['nama'] ?? json['nama_kategori'] ?? '',
      slug: json['slug'] ?? '',
      deskripsi: json['deskripsi'],
      ikon: json['ikon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'slug': slug,
      'deskripsi': deskripsi,
      'ikon': ikon,
    };
  }
}
