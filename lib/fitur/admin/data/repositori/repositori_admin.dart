import 'package:dio/dio.dart';
import '../../../../inti/jaringan/hasil_api.dart';
import '../../../../inti/jaringan/klien_api.dart';
import '../../../../inti/konstanta/konstanta_api.dart';
import '../model/ringkasan_admin_model.dart';

class RepositoriAdmin {
  final Dio _dio = KlienApi.instance;

  static const RingkasanAdminModel _mockRingkasan = RingkasanAdminModel(
    totalOmset: 18750000,
    totalPesanan: 42,
    pesananDiproses: 6,
    pesananMenungguBayar: 2,
    totalPelanggan: 128,
    totalProdukAktif: 24,
  );

  Future<HasilApi<RingkasanAdminModel>> ambilRingkasan() async {
    try {
      final respon = await _dio.get(KonstantaApi.adminDashboard);
      if (respon.statusCode == 200 && respon.data['sukses'] == true) {
        final data = RingkasanAdminModel.fromJson(respon.data['data']);
        return ApiSukses(data);
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal memuat ringkasan admin');
    } catch (_) {
      return const ApiSukses(_mockRingkasan, pesan: 'Mode Lokal Terhubung');
    }
  }
}
