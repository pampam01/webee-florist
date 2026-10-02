import 'package:dio/dio.dart';
import 'package:webee_florist/fitur/pesanan/data/model/pesanan_model.dart';
import 'package:webee_florist/inti/jaringan/hasil_api.dart';
import 'package:webee_florist/inti/jaringan/klien_api.dart';
import 'package:webee_florist/inti/konstanta/konstanta_api.dart';

class RepositoriPesanan {
  final Dio _dio = KlienApi.instance;

  static final List<PesananModel> _mockPesanan = [
    const PesananModel(
      id: 101,
      nomorPesanan: 'WBF-20261002-001A',
      penggunaId: 2,
      totalHarga: 650000,
      biayaKirim: 35000,
      grandTotal: 685000,
      status: 'diproses',
      namaPenerima: 'Lady Genevieve',
      teleponPenerima: '081234567890',
      alamatPengiriman: 'Kebayoran Baru, Jl. Senopati No. 45, Jakarta Selatan',
      pesanKartuUcapan: 'Semoga hari bahagiamu seharum kelopak mawar kastil Provence.',
      tanggalKirim: '2026-10-02',
      metodePembayaran: 'QRIS',
      stempelWaktu: '2026-10-02 08:30:00',
      jenisKurir: 'armada_mobil_berpendingin',
      namaKurir: 'Budi Santoso',
      teleponKurir: '081299887766',
      nomorResi: 'WBF-VAN-01',
      estimasiJamKirim: '14:00 - 16:00',
      itemPesanan: [
        ItemPesananModel(
          id: 1,
          pesananId: 101,
          produkId: 1,
          kuantitas: 1,
          hargaSatuan: 650000,
          subtotal: 650000,
          namaProdukSnapshot: 'Buket Mawar Merah Kastil Provence (24 Tangkai)',
        ),
      ],
    ),
    const PesananModel(
      id: 102,
      nomorPesanan: 'WBF-20261002-002B',
      penggunaId: 3,
      totalHarga: 450000,
      biayaKirim: 25000,
      grandTotal: 475000,
      status: 'dikirim',
      namaPenerima: 'Madame Vivienne',
      teleponPenerima: '081377889900',
      alamatPengiriman: 'Menteng Residensi Blok C2 No. 8, Jakarta Pusat',
      pesanKartuUcapan: 'Selamat hari jadi pernikahan ke-10, cinta abadi.',
      tanggalKirim: '2026-10-02',
      metodePembayaran: 'Transfer Bank BCA',
      stempelWaktu: '2026-10-02 09:15:00',
      jenisKurir: 'kurir_motor_florist',
      namaKurir: 'Rian Hidayat',
      teleponKurir: '087711223344',
      nomorResi: 'WBF-MTR-05',
      estimasiJamKirim: '11:00 - 13:00',
      itemPesanan: [
        ItemPesananModel(
          id: 2,
          pesananId: 102,
          produkId: 2,
          kuantitas: 1,
          hargaSatuan: 450000,
          subtotal: 450000,
          namaProdukSnapshot: 'Buket Lavender & Lily Parisien',
        ),
      ],
    ),
    const PesananModel(
      id: 103,
      nomorPesanan: 'WBF-20261002-003C',
      penggunaId: 4,
      totalHarga: 850000,
      biayaKirim: 40000,
      grandTotal: 890000,
      status: 'menunggu_pembayaran',
      namaPenerima: 'Sir Arthur Wellesley',
      teleponPenerima: '085699001122',
      alamatPengiriman: 'Pondok Indah Bukit Hijau Blok D No. 14, Jakarta Selatan',
      pesanKartuUcapan: 'With deepest admiration and appreciation for your noble leadership.',
      tanggalKirim: '2026-10-03',
      metodePembayaran: 'Virtual Account Mandiri',
      stempelWaktu: '2026-10-02 10:45:00',
      itemPesanan: [
        ItemPesananModel(
          id: 3,
          pesananId: 103,
          produkId: 3,
          kuantitas: 1,
          hargaSatuan: 850000,
          subtotal: 850000,
          namaProdukSnapshot: 'Vas Kristal Anggrek Bulan Artisan Putih',
        ),
      ],
    ),
    const PesananModel(
      id: 104,
      nomorPesanan: 'WBF-20261001-088Z',
      penggunaId: 5,
      totalHarga: 320000,
      biayaKirim: 20000,
      grandTotal: 340000,
      status: 'selesai',
      namaPenerima: 'Aurelie Putri',
      teleponPenerima: '081900112233',
      alamatPengiriman: 'Apartemen Sudirman Tower A Lantai 18, Jakarta',
      pesanKartuUcapan: 'Happy Graduation dokter cantik! Sangat bangga padamu.',
      tanggalKirim: '2026-10-01',
      metodePembayaran: 'QRIS',
      stempelWaktu: '2026-10-01 13:00:00',
      jenisKurir: 'kurir_motor_florist',
      namaKurir: 'Rian Hidayat',
      teleponKurir: '087711223344',
      nomorResi: 'WBF-MTR-02',
      estimasiJamKirim: '14:30',
      itemPesanan: [
        ItemPesananModel(
          id: 4,
          pesananId: 104,
          produkId: 4,
          kuantitas: 1,
          hargaSatuan: 320000,
          subtotal: 320000,
          namaProdukSnapshot: 'Buket Hydrangea Biru Versailles',
        ),
      ],
    ),
  ];

  Future<HasilApi<PesananModel>> buatPesanan({
    required String namaPenerima,
    required String teleponPenerima,
    required String alamatPengiriman,
    String? pesanKartuUcapan,
    String? tanggalKirim,
    String metodePembayaran = 'QRIS',
  }) async {
    try {
      final respon = await _dio.post(
        KonstantaApi.pesanan,
        data: {
          'nama_penerima': namaPenerima,
          'telepon_penerima': teleponPenerima,
          'alamat_pengiriman': alamatPengiriman,
          'pesan_kartu_ucapan': pesanKartuUcapan,
          'tanggal_kirim': tanggalKirim,
          'metode_pembayaran': metodePembayaran,
        },
      );

      if (respon.statusCode == 201 && respon.data['sukses'] == true) {
        final data = PesananModel.fromJson(respon.data['data']);
        return ApiSukses(data, pesan: respon.data['pesan'] ?? 'Pesanan berhasil dibuat');
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal membuat pesanan');
    } catch (_) {
      final idBaru = DateTime.now().millisecondsSinceEpoch % 10000;
      final pesananBaru = PesananModel(
        id: idBaru,
        nomorPesanan: 'WBF-${DateTime.now().year}$idBaru',
        penggunaId: 1,
        totalHarga: 450000,
        biayaKirim: 20000,
        grandTotal: 470000,
        status: 'menunggu_pembayaran',
        namaPenerima: namaPenerima,
        teleponPenerima: teleponPenerima,
        alamatPengiriman: alamatPengiriman,
        pesanKartuUcapan: pesanKartuUcapan,
        tanggalKirim: tanggalKirim,
        metodePembayaran: metodePembayaran,
        stempelWaktu: DateTime.now().toString().substring(0, 19),
      );
      _mockPesanan.insert(0, pesananBaru);
      return ApiSukses(pesananBaru, pesan: 'Pesanan berhasil dibuat (Mode Pengembang)');
    }
  }

  Future<HasilApi<List<PesananModel>>> ambilRiwayat() async {
    try {
      final respon = await _dio.get(KonstantaApi.riwayatPesanan);
      if (respon.statusCode == 200 && respon.data['sukses'] == true) {
        final list = (respon.data['data'] as List)
            .map((e) => PesananModel.fromJson(e))
            .toList();
        return ApiSukses(list);
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal memuat riwayat');
    } catch (_) {
      return ApiSukses(List.from(_mockPesanan));
    }
  }

  Future<HasilApi<List<PesananModel>>> ambilSemuaPesananAdmin({
    String? status,
    String? cari,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (status != null && status.isNotEmpty && status != 'semua') {
        query['status'] = status;
      }
      if (cari != null && cari.trim().isNotEmpty) {
        query['cari'] = cari.trim();
      }

      final respon = await _dio.get(
        KonstantaApi.adminPesanan,
        queryParameters: query,
      );

      if (respon.statusCode == 200 && respon.data['sukses'] == true) {
        final list = (respon.data['data'] as List)
            .map((e) => PesananModel.fromJson(e))
            .toList();
        return ApiSukses(list);
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal memuat data pesanan admin');
    } catch (_) {
      // Filter mock data offline
      var hasil = List<PesananModel>.from(_mockPesanan);
      if (status != null && status.isNotEmpty && status != 'semua') {
        hasil = hasil.where((p) => p.status == status).toList();
      }
      if (cari != null && cari.trim().isNotEmpty) {
        final q = cari.trim().toLowerCase();
        hasil = hasil.where((p) {
          return p.nomorPesanan.toLowerCase().contains(q) ||
              p.namaPenerima.toLowerCase().contains(q) ||
              p.teleponPenerima.toLowerCase().contains(q) ||
              p.alamatPengiriman.toLowerCase().contains(q);
        }).toList();
      }
      return ApiSukses(hasil);
    }
  }

  Future<HasilApi<bool>> ubahStatusPesanan(int pesananId, String status) async {
    return perbaruiStatusDanLogistik(pesananId: pesananId, status: status);
  }

  Future<HasilApi<bool>> perbaruiStatusDanLogistik({
    required int pesananId,
    required String status,
    Map<String, dynamic>? dataLogistik,
  }) async {
    final payload = <String, dynamic>{'status': status};
    if (dataLogistik != null) {
      payload.addAll(dataLogistik);
    }

    try {
      final respon = await _dio.patch(
        '${KonstantaApi.pesanan}/$pesananId/status',
        data: payload,
      );
      if (respon.statusCode == 200) {
        // update local mock if present
        _sinkronkanMockLokal(pesananId, status, dataLogistik);
        return const ApiSukses(true);
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal memperbarui status');
    } catch (_) {
      _sinkronkanMockLokal(pesananId, status, dataLogistik);
      return const ApiSukses(true);
    }
  }

  void _sinkronkanMockLokal(int pesananId, String status, Map<String, dynamic>? logistik) {
    final idx = _mockPesanan.indexWhere((p) => p.id == pesananId);
    if (idx >= 0) {
      _mockPesanan[idx] = _mockPesanan[idx].copyWith(
        status: status,
        jenisKurir: logistik?['jenis_kurir'] ?? _mockPesanan[idx].jenisKurir,
        namaKurir: logistik?['nama_kurir'] ?? _mockPesanan[idx].namaKurir,
        teleponKurir: logistik?['telepon_kurir'] ?? _mockPesanan[idx].teleponKurir,
        nomorResi: logistik?['nomor_resi'] ?? _mockPesanan[idx].nomorResi,
        estimasiJamKirim: logistik?['estimasi_jam_kirim'] ?? _mockPesanan[idx].estimasiJamKirim,
      );
    }
  }
}
