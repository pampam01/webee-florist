class RingkasanAdminModel {
  final double totalOmset;
  final int totalPesanan;
  final int pesananDiproses;
  final int pesananMenungguBayar;
  final int totalPelanggan;
  final int totalProdukAktif;

  const RingkasanAdminModel({
    required this.totalOmset,
    required this.totalPesanan,
    required this.pesananDiproses,
    required this.pesananMenungguBayar,
    required this.totalPelanggan,
    required this.totalProdukAktif,
  });

  factory RingkasanAdminModel.fromJson(Map<String, dynamic> json) {
    return RingkasanAdminModel(
      totalOmset: json['total_omset'] != null
          ? double.tryParse(json['total_omset'].toString()) ?? 0.0
          : 0.0,
      totalPesanan: json['total_pesanan'] is int
          ? json['total_pesanan']
          : int.tryParse(json['total_pesanan'].toString()) ?? 0,
      pesananDiproses: json['pesanan_diproses'] is int
          ? json['pesanan_diproses']
          : int.tryParse(json['pesanan_diproses'].toString()) ?? 0,
      pesananMenungguBayar: json['pesanan_menunggu_bayar'] is int
          ? json['pesanan_menunggu_bayar']
          : int.tryParse(json['pesanan_menunggu_bayar'].toString()) ?? 0,
      totalPelanggan: json['total_pelanggan'] is int
          ? json['total_pelanggan']
          : int.tryParse(json['total_pelanggan'].toString()) ?? 0,
      totalProdukAktif: json['total_produk_aktif'] is int
          ? json['total_produk_aktif']
          : int.tryParse(json['total_produk_aktif'].toString()) ?? 0,
    );
  }
}
