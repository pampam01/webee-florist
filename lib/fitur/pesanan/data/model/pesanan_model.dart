import 'package:webee_florist/fitur/katalog_bunga/data/model/produk_model.dart';

class ItemPesananModel {
  final int id;
  final int pesananId;
  final int produkId;
  final int kuantitas;
  final double hargaSatuan;
  final double subtotal;
  final String? namaProdukSnapshot;
  final ProdukBungaModel? produk;

  const ItemPesananModel({
    required this.id,
    required this.pesananId,
    required this.produkId,
    required this.kuantitas,
    required this.hargaSatuan,
    required this.subtotal,
    this.namaProdukSnapshot,
    this.produk,
  });

  factory ItemPesananModel.fromJson(Map<String, dynamic> json) {
    return ItemPesananModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      pesananId: json['pesanan_id'] is int
          ? json['pesanan_id']
          : int.tryParse(json['pesanan_id'].toString()) ?? 0,
      produkId: json['produk_id'] is int
          ? json['produk_id']
          : int.tryParse(json['produk_id'].toString()) ?? 0,
      kuantitas: json['kuantitas'] is int
          ? json['kuantitas']
          : int.tryParse(json['kuantitas'].toString()) ?? 1,
      hargaSatuan: json['harga_satuan'] != null
          ? double.tryParse(json['harga_satuan'].toString()) ?? 0.0
          : 0.0,
      subtotal: json['subtotal'] != null
          ? double.tryParse(json['subtotal'].toString()) ?? 0.0
          : 0.0,
      namaProdukSnapshot: json['nama_produk_snapshot'] ?? json['nama_produk'],
      produk: json['produk'] != null && json['produk'] is Map<String, dynamic>
          ? ProdukBungaModel.fromJson(json['produk'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pesanan_id': pesananId,
      'produk_id': produkId,
      'kuantitas': kuantitas,
      'harga_satuan': hargaSatuan,
      'subtotal': subtotal,
      'nama_produk_snapshot': namaProdukSnapshot,
    };
  }
}

class PesananModel {
  final int id;
  final String nomorPesanan;
  final int penggunaId;
  final double totalHarga;
  final double biayaKirim;
  final double grandTotal;
  final String status; // 'menunggu_pembayaran', 'diproses', 'dikirim', 'selesai', 'dibatalkan'
  final String namaPenerima;
  final String teleponPenerima;
  final String alamatPengiriman;
  final String? pesanKartuUcapan;
  final String? tanggalKirim;
  final String? metodePembayaran;
  final String? stempelWaktu;
  final String? jenisKurir;
  final String? namaKurir;
  final String? teleponKurir;
  final String? nomorResi;
  final String? estimasiJamKirim;
  final List<ItemPesananModel> itemPesanan;

  const PesananModel({
    required this.id,
    required this.nomorPesanan,
    required this.penggunaId,
    required this.totalHarga,
    required this.biayaKirim,
    required this.grandTotal,
    required this.status,
    required this.namaPenerima,
    required this.teleponPenerima,
    required this.alamatPengiriman,
    this.pesanKartuUcapan,
    this.tanggalKirim,
    this.metodePembayaran,
    this.stempelWaktu,
    this.jenisKurir,
    this.namaKurir,
    this.teleponKurir,
    this.nomorResi,
    this.estimasiJamKirim,
    this.itemPesanan = const [],
  });

  factory PesananModel.fromJson(Map<String, dynamic> json) {
    var rawItems = json['item_pesanan'] ?? json['items'] ?? json['item'];
    List<ItemPesananModel> parsedItems = [];
    if (rawItems is List) {
      parsedItems = rawItems.map((e) => ItemPesananModel.fromJson(e)).toList();
    }

    return PesananModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      nomorPesanan: json['nomor_pesanan'] ?? '',
      penggunaId: json['pengguna_id'] is int
          ? json['pengguna_id']
          : (json['id_pelanggan'] is int ? json['id_pelanggan'] : int.tryParse(json['pengguna_id']?.toString() ?? json['id_pelanggan']?.toString() ?? '0') ?? 0),
      totalHarga: json['total_harga'] != null
          ? double.tryParse(json['total_harga'].toString()) ?? 0.0
          : 0.0,
      biayaKirim: json['biaya_kirim'] != null
          ? double.tryParse(json['biaya_kirim'].toString()) ?? 0.0
          : 0.0,
      grandTotal: json['grand_total'] != null
          ? double.tryParse(json['grand_total'].toString()) ?? 0.0
          : (json['total_harga'] != null ? double.tryParse(json['total_harga'].toString()) ?? 0.0 : 0.0),
      status: json['status'] ?? 'menunggu_pembayaran',
      namaPenerima: json['nama_penerima'] ?? '',
      teleponPenerima: json['telepon_penerima'] ?? '',
      alamatPengiriman: json['alamat_pengiriman'] ?? '',
      pesanKartuUcapan: json['pesan_kartu_ucapan'] ?? json['kartu_ucapan'],
      tanggalKirim: json['tanggal_kirim'] ?? json['tanggal_pengiriman'],
      metodePembayaran: json['metode_pembayaran'],
      stempelWaktu: json['created_at'] ?? json['stempel_waktu'],
      jenisKurir: json['jenis_kurir'],
      namaKurir: json['nama_kurir'],
      teleponKurir: json['telepon_kurir'],
      nomorResi: json['nomor_resi'],
      estimasiJamKirim: json['estimasi_jam_kirim'],
      itemPesanan: parsedItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomor_pesanan': nomorPesanan,
      'pengguna_id': penggunaId,
      'total_harga': totalHarga,
      'biaya_kirim': biayaKirim,
      'grand_total': grandTotal,
      'status': status,
      'nama_penerima': namaPenerima,
      'telepon_penerima': teleponPenerima,
      'alamat_pengiriman': alamatPengiriman,
      'pesan_kartu_ucapan': pesanKartuUcapan,
      'tanggal_kirim': tanggalKirim,
      'metode_pembayaran': metodePembayaran,
      'jenis_kurir': jenisKurir,
      'nama_kurir': namaKurir,
      'telepon_kurir': teleponKurir,
      'nomor_resi': nomorResi,
      'estimasi_jam_kirim': estimasiJamKirim,
    };
  }

  PesananModel copyWith({
    String? status,
    String? jenisKurir,
    String? namaKurir,
    String? teleponKurir,
    String? nomorResi,
    String? estimasiJamKirim,
    String? pesanKartuUcapan,
    String? tanggalKirim,
  }) {
    return PesananModel(
      id: id,
      nomorPesanan: nomorPesanan,
      penggunaId: penggunaId,
      totalHarga: totalHarga,
      biayaKirim: biayaKirim,
      grandTotal: grandTotal,
      status: status ?? this.status,
      namaPenerima: namaPenerima,
      teleponPenerima: teleponPenerima,
      alamatPengiriman: alamatPengiriman,
      pesanKartuUcapan: pesanKartuUcapan ?? this.pesanKartuUcapan,
      tanggalKirim: tanggalKirim ?? this.tanggalKirim,
      metodePembayaran: metodePembayaran,
      stempelWaktu: stempelWaktu,
      jenisKurir: jenisKurir ?? this.jenisKurir,
      namaKurir: namaKurir ?? this.namaKurir,
      teleponKurir: teleponKurir ?? this.teleponKurir,
      nomorResi: nomorResi ?? this.nomorResi,
      estimasiJamKirim: estimasiJamKirim ?? this.estimasiJamKirim,
      itemPesanan: itemPesanan,
    );
  }
}
