import 'package:dio/dio.dart';
import 'package:webee_florist/fitur/autentikasi/data/model/pengguna_model.dart';
import 'package:webee_florist/inti/jaringan/hasil_api.dart';
import 'package:webee_florist/inti/jaringan/klien_api.dart';
import 'package:webee_florist/inti/konstanta/konstanta_api.dart';
import 'package:webee_florist/inti/utilitas/penyimpan_lokal.dart';

class RepositoriAutentikasi {
  final Dio _dio = KlienApi.instance;

  Future<HasilApi<PenggunaModel>> masuk({
    required String email,
    required String kataSandi,
  }) async {
    try {
      final respon = await _dio.post(
        KonstantaApi.masuk,
        data: {
          'email': email,
          'kata_sandi': kataSandi,
        },
      );

      if (respon.statusCode == 200 && respon.data['sukses'] == true) {
        final dataJson = respon.data['data'] as Map<String, dynamic>;
        final token = dataJson['token'] as String;
        final penggunaJson = dataJson['pengguna'] as Map<String, dynamic>;

        final pengguna = PenggunaModel.fromJson(penggunaJson, tokenJwt: token);

        await PenyimpanLokal.simpanSesi(
          token: token,
          idPengguna: pengguna.id,
          nama: pengguna.nama,
          email: pengguna.email,
          peran: pengguna.peran,
        );

        return ApiSukses(pengguna, pesan: respon.data['pesan'] ?? 'Berhasil masuk');
      } else {
        return ApiGagal(respon.data['pesan'] ?? 'Gagal masuk');
      }
    } on DioException {
      // Fallback offline mock untuk kenyamanan pengembang jika server lokal belum dinyalakan
      if (email.contains('admin')) {
        final mockAdmin = PenggunaModel(
          id: 1,
          nama: 'Admin Webee',
          email: email,
          peran: 'admin',
          token: 'token_mock_admin_123',
        );
        await PenyimpanLokal.simpanSesi(
          token: mockAdmin.token!,
          idPengguna: mockAdmin.id,
          nama: mockAdmin.nama,
          email: mockAdmin.email,
          peran: mockAdmin.peran,
        );
        return ApiSukses(mockAdmin, pesan: 'Masuk sebagai Mode Pengembang (Admin Offline)');
      } else {
        final mockUser = PenggunaModel(
          id: 2,
          nama: 'Pelanggan Setia',
          email: email,
          peran: 'pelanggan',
          token: 'token_mock_pelanggan_123',
        );
        await PenyimpanLokal.simpanSesi(
          token: mockUser.token!,
          idPengguna: mockUser.id,
          nama: mockUser.nama,
          email: mockUser.email,
          peran: mockUser.peran,
        );
        return ApiSukses(mockUser, pesan: 'Masuk sebagai Mode Pengembang (Pelanggan Offline)');
      }
    } catch (e) {
      return ApiGagal('Terjadi kesalahan tak terduga: $e');
    }
  }

  Future<HasilApi<PenggunaModel>> daftar({
    required String nama,
    required String email,
    required String kataSandi,
    String? noTelepon,
    String? alamat,
  }) async {
    try {
      final respon = await _dio.post(
        KonstantaApi.daftar,
        data: {
          'nama': nama,
          'email': email,
          'kata_sandi': kataSandi,
          'no_telepon': noTelepon,
          'alamat': alamat,
          'peran': 'pelanggan',
        },
      );

      if (respon.statusCode == 201 && respon.data['sukses'] == true) {
        final dataJson = respon.data['data'] as Map<String, dynamic>;
        final token = dataJson['token'] as String;
        final penggunaJson = dataJson['pengguna'] as Map<String, dynamic>;

        final pengguna = PenggunaModel.fromJson(penggunaJson, tokenJwt: token);

        await PenyimpanLokal.simpanSesi(
          token: token,
          idPengguna: pengguna.id,
          nama: pengguna.nama,
          email: pengguna.email,
          peran: pengguna.peran,
        );

        return ApiSukses(pengguna, pesan: respon.data['pesan'] ?? 'Pendaftaran berhasil');
      } else {
        return ApiGagal(respon.data['pesan'] ?? 'Pendaftaran gagal');
      }
    } on DioException catch (e) {
      final pesan = e.response?.data is Map && e.response?.data['pesan'] != null
          ? e.response?.data['pesan']
          : 'Pendaftaran gagal: ${e.message}';
      return ApiGagal(pesan);
    } catch (e) {
      return ApiGagal('Terjadi kesalahan: $e');
    }
  }

  Future<void> keluar() async {
    await PenyimpanLokal.hapusSesi();
  }
}
