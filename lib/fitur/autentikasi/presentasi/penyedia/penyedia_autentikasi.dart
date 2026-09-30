import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/autentikasi/data/model/pengguna_model.dart';
import 'package:webee_florist/fitur/autentikasi/data/repositori/repositori_autentikasi.dart';
import 'package:webee_florist/inti/jaringan/hasil_api.dart';
import 'package:webee_florist/inti/utilitas/penyimpan_lokal.dart';

final repositoriAutentikasiProvider = Provider<RepositoriAutentikasi>((ref) {
  return RepositoriAutentikasi();
});

class StateAutentikasi {
  final PenggunaModel? pengguna;
  final bool sedangMemuat;
  final String? pesanKesalahan;

  const StateAutentikasi({
    this.pengguna,
    this.sedangMemuat = false,
    this.pesanKesalahan,
  });

  bool get sudahMasuk => pengguna != null;
  bool get isAdmin => pengguna?.isAdmin ?? false;

  StateAutentikasi copyWith({
    PenggunaModel? pengguna,
    bool? sedangMemuat,
    String? pesanKesalahan,
    bool hapusPengguna = false,
  }) {
    return StateAutentikasi(
      pengguna: hapusPengguna ? null : (pengguna ?? this.pengguna),
      sedangMemuat: sedangMemuat ?? this.sedangMemuat,
      pesanKesalahan: pesanKesalahan,
    );
  }
}

class NotifierAutentikasi extends StateNotifier<StateAutentikasi> {
  final RepositoriAutentikasi _repositori;

  NotifierAutentikasi(this._repositori) : super(const StateAutentikasi()) {
    _cekSesiTersimpan();
  }

  Future<void> _cekSesiTersimpan() async {
    final token = await PenyimpanLokal.ambilToken();
    if (token != null && token.isNotEmpty) {
      final peran = await PenyimpanLokal.ambilPeran() ?? 'pelanggan';
      final nama = await PenyimpanLokal.ambilNama() ?? 'Pengguna Webee';
      final email = await PenyimpanLokal.ambilEmail() ?? 'user@webee.com';

      state = state.copyWith(
        pengguna: PenggunaModel(
          id: 1,
          nama: nama,
          email: email,
          peran: peran,
          token: token,
        ),
      );
    }
  }

  Future<bool> masuk(String email, String kataSandi) async {
    state = state.copyWith(sedangMemuat: true, pesanKesalahan: null);
    final hasil = await _repositori.masuk(email: email, kataSandi: kataSandi);

    if (hasil is ApiSukses<PenggunaModel>) {
      state = state.copyWith(
        pengguna: hasil.data,
        sedangMemuat: false,
        pesanKesalahan: null,
      );
      return true;
    } else if (hasil is ApiGagal<PenggunaModel>) {
      state = state.copyWith(
        sedangMemuat: false,
        pesanKesalahan: hasil.pesanKesalahan,
      );
      return false;
    }
    state = state.copyWith(sedangMemuat: false);
    return false;
  }

  Future<bool> daftar({
    required String nama,
    required String email,
    required String kataSandi,
    String? noTelepon,
    String? alamat,
  }) async {
    state = state.copyWith(sedangMemuat: true, pesanKesalahan: null);
    final hasil = await _repositori.daftar(
      nama: nama,
      email: email,
      kataSandi: kataSandi,
      noTelepon: noTelepon,
      alamat: alamat,
    );

    if (hasil is ApiSukses<PenggunaModel>) {
      state = state.copyWith(
        pengguna: hasil.data,
        sedangMemuat: false,
        pesanKesalahan: null,
      );
      return true;
    } else if (hasil is ApiGagal<PenggunaModel>) {
      state = state.copyWith(
        sedangMemuat: false,
        pesanKesalahan: hasil.pesanKesalahan,
      );
      return false;
    }
    state = state.copyWith(sedangMemuat: false);
    return false;
  }

  Future<void> keluar() async {
    await _repositori.keluar();
    state = const StateAutentikasi();
  }

  void gantiPeranDemo(String peranBaru) {
    if (state.pengguna != null) {
      final penggunaBaru = state.pengguna!.copyWith(peran: peranBaru);
      state = state.copyWith(pengguna: penggunaBaru);
      PenyimpanLokal.simpanSesi(
        token: penggunaBaru.token ?? 'mock_token',
        idPengguna: penggunaBaru.id,
        nama: penggunaBaru.nama,
        email: penggunaBaru.email,
        peran: penggunaBaru.peran,
      );
    }
  }
}

final autentikasiProvider =
    StateNotifierProvider<NotifierAutentikasi, StateAutentikasi>((ref) {
  final repositori = ref.watch(repositoriAutentikasiProvider);
  return NotifierAutentikasi(repositori);
});
