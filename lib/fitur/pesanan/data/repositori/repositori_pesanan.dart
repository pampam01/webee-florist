import 'package:dio/dio.dart';
import 'package:webee_florist/fitur/pesanan/data/model/pesanan_model.dart';
import 'package:webee_florist/inti/jaringan/hasil_api.dart';
import 'package:webee_florist/inti/jaringan/klien_api.dart';
import 'package:webee_florist/inti/konstanta/konstanta_api.dart';

class RepositoriPesanan {
  final Dio _dio = KlienApi.instance;

  static final List<PesananModel> _mockPesanan = [
    const PesananModel(
      id: 1,
      nomorPesanan: 'WBF-20261001-001',
      penggunaId: 2,
      totalHarga: 450000,
      biayaKirim: 25000,
      grandTotal: 475000,
      status: 'diproses',
      namaPenerima: 'Clara Anindya',
      teleponPenerima: '081298765432',
      alamatPengiriman: 'Jl. Senopati No. 45, Kebayoran Baru, Jakarta Selatan',
      pesanKartuUcapan: 'Selamat ulang tahun yang terindah, Clara tercinta.',
      tanggalKirim: '2026-10-02',
      metodePembayaran: 'QRIS',
      stempelWaktu: '2026-10-01 10:15:00',
      itemPesanan: [
        ItemPesananModel(
          id: 1,
          pesananId: 1,
          produkId: 1,
          kuantitas: 1,
          hargaSatuan: 450000,
          subtotal: 450000,
          namaProdukSnapshot: 'Royal Velvet Red Roses (24 Tangkai)',
        ),
      ],
    ),
    const PesananModel(
      id: 2,
      nomorPesanan: 'WBF-20260928-088',
      penggunaId: 2,
      totalHarga: 280000,
      biayaKirim: 20000,
      grandTotal: 300000,
      status: 'selesai',
      namaPenerima: 'Rian Pratama',
      teleponPenerima: '087788990011',
      alamatPengiriman: 'Gedung Rektorat Kampus UI, Depok',
      pesanKartuUcapan: 'Selamat atas kelulusan Anda! Sukses selalu dalam perjalanan karier.',
      tanggalKirim: '2026-09-29',
      metodePembayaran: 'Transfer Bank BCA',
      stempelWaktu: '2026-09-28 14:00:00',
      itemPesanan: [
        ItemPesananModel(
          id: 2,
          pesananId: 2,
          produkId: 5,
          kuantitas: 1,
          hargaSatuan: 280000,
          subtotal: 280000,
          namaProdukSnapshot: 'Sunflower Sunburst Graduation Bouquet',
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

  Future<HasilApi<bool>> ubahStatusPesanan(int pesananId, String status) async {
    try {
      final respon = await _dio.put(
        '${KonstantaApi.pesanan}/$pesananId/status',
        data: {'status': status},
      );
      if (respon.statusCode == 200) {
        return const ApiSukses(true);
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal update status');
    } catch (_) {
      final idx = _mockPesanan.indexWhere((p) => p.id == pesananId);
      if (idx >= 0) {
        _mockPesanan[idx] = _mockPesanan[idx].copyWith(status: status);
      }
      return const ApiSukses(true);
    }
  }
}
