import 'package:webee_florist/fitur/katalog_bunga/data/model/produk_model.dart';

class ItemKeranjangModel {
  final int id;
  final int penggunaId;
  final int produkId;
  final int kuantitas;
  final String? catatanKhusus;
  final ProdukBungaModel? produk;

  const ItemKeranjangModel({
    required this.id,
    required this.penggunaId,
    required this.produkId,
    required this.kuantitas,
    this.catatanKhusus,
    this.produk,
  });

  double get subtotal => (produk?.harga ?? 0) * kuantitas;

  factory ItemKeranjangModel.fromJson(Map<String, dynamic> json) {
    return ItemKeranjangModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      penggunaId: json['pengguna_id'] is int
          ? json['pengguna_id']
          : int.tryParse(json['pengguna_id'].toString()) ?? 0,
      produkId: json['produk_id'] is int
          ? json['produk_id']
          : int.tryParse(json['produk_id'].toString()) ?? 0,
      kuantitas: json['kuantitas'] is int
          ? json['kuantitas']
          : int.tryParse(json['kuantitas'].toString()) ?? 1,
      catatanKhusus: json['catatan_khusus'],
      produk: json['produk'] != null && json['produk'] is Map<String, dynamic>
          ? ProdukBungaModel.fromJson(json['produk'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pengguna_id': penggunaId,
      'produk_id': produkId,
      'kuantitas': kuantitas,
      'catatan_khusus': catatanKhusus,
      'produk': produk?.toJson(),
    };
  }

  ItemKeranjangModel copyWith({
    int? id,
    int? penggunaId,
    int? produkId,
    int? kuantitas,
    String? catatanKhusus,
    ProdukBungaModel? produk,
  }) {
    return ItemKeranjangModel(
      id: id ?? this.id,
      penggunaId: penggunaId ?? this.penggunaId,
      produkId: produkId ?? this.produkId,
      kuantitas: kuantitas ?? this.kuantitas,
      catatanKhusus: catatanKhusus ?? this.catatanKhusus,
      produk: produk ?? this.produk,
    );
  }
}
