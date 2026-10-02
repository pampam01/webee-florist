import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/keranjang/presentasi/penyedia/penyedia_keranjang.dart';
import 'package:webee_florist/fitur/pesanan/data/model/pesanan_model.dart';
import 'package:webee_florist/fitur/pesanan/data/repositori/repositori_pesanan.dart';
import 'package:webee_florist/inti/jaringan/hasil_api.dart';

final repositoriPesananProvider = Provider<RepositoriPesanan>((ref) {
  return RepositoriPesanan();
});

final riwayatPesananProvider = FutureProvider<List<PesananModel>>((ref) async {
  final repo = ref.watch(repositoriPesananProvider);
  final hasil = await repo.ambilRiwayat();
  if (hasil is ApiSukses<List<PesananModel>>) {
    return hasil.data;
  }
  return [];
});

class StateBuatPesanan {
  final bool sedangMemuat;
  final PesananModel? pesananDibuat;
  final String? pesanKesalahan;

  const StateBuatPesanan({
    this.sedangMemuat = false,
    this.pesananDibuat,
    this.pesanKesalahan,
  });
}

class NotifierBuatPesanan extends StateNotifier<StateBuatPesanan> {
  final RepositoriPesanan _repositori;
  final Ref _ref;

  NotifierBuatPesanan(this._repositori, this._ref)
      : super(const StateBuatPesanan());

  Future<bool> kirimPesanan({
    required String namaPenerima,
    required String teleponPenerima,
    required String alamatPengiriman,
    String? pesanKartuUcapan,
    String? tanggalKirim,
    String metodePembayaran = 'QRIS',
  }) async {
    state = const StateBuatPesanan(sedangMemuat: true);
    final hasil = await _repositori.buatPesanan(
      namaPenerima: namaPenerima,
      teleponPenerima: teleponPenerima,
      alamatPengiriman: alamatPengiriman,
      pesanKartuUcapan: pesanKartuUcapan,
      tanggalKirim: tanggalKirim,
      metodePembayaran: metodePembayaran,
    );

    if (hasil is ApiSukses<PesananModel>) {
      state = StateBuatPesanan(
        sedangMemuat: false,
        pesananDibuat: hasil.data,
      );
      await _ref.read(keranjangProvider.notifier).kosongkanKeranjang();
      _ref.invalidate(riwayatPesananProvider);
      return true;
    } else if (hasil is ApiGagal<PesananModel>) {
      state = StateBuatPesanan(
        sedangMemuat: false,
        pesanKesalahan: hasil.pesanKesalahan,
      );
      return false;
    }
    state = const StateBuatPesanan(sedangMemuat: false);
    return false;
  }

  Future<void> perbaruiStatusPesanan(int pesananId, String status) async {
    await _repositori.ubahStatusPesanan(pesananId, status);
    _ref.invalidate(riwayatPesananProvider);
    _ref.invalidate(daftarPesananAdminProvider);
  }
}

final buatPesananProvider =
    StateNotifierProvider<NotifierBuatPesanan, StateBuatPesanan>((ref) {
  final repo = ref.watch(repositoriPesananProvider);
  return NotifierBuatPesanan(repo, ref);
});

final filterStatusPesananAdminProvider = StateProvider<String>((ref) => 'semua');
final kataKunciCariAdminProvider = StateProvider<String>((ref) => '');

final daftarPesananAdminProvider = FutureProvider<List<PesananModel>>((ref) async {
  final repo = ref.watch(repositoriPesananProvider);
  final status = ref.watch(filterStatusPesananAdminProvider);
  final cari = ref.watch(kataKunciCariAdminProvider);

  final hasil = await repo.ambilSemuaPesananAdmin(
    status: status == 'semua' ? null : status,
    cari: cari.isEmpty ? null : cari,
  );

  if (hasil is ApiSukses<List<PesananModel>>) {
    return hasil.data;
  }
  return [];
});

class NotifierAdminPesanan extends StateNotifier<bool> {
  final RepositoriPesanan _repositori;
  final Ref _ref;

  NotifierAdminPesanan(this._repositori, this._ref) : super(false);

  Future<bool> ubahStatusDanLogistik({
    required int pesananId,
    required String statusBaru,
    Map<String, dynamic>? dataLogistik,
  }) async {
    state = true;
    final hasil = await _repositori.perbaruiStatusDanLogistik(
      pesananId: pesananId,
      status: statusBaru,
      dataLogistik: dataLogistik,
    );
    state = false;

    if (hasil is ApiSukses<bool> && hasil.data) {
      _ref.invalidate(daftarPesananAdminProvider);
      _ref.invalidate(riwayatPesananProvider);
      return true;
    }
    return false;
  }
}

final aksiPesananAdminProvider =
    StateNotifierProvider<NotifierAdminPesanan, bool>((ref) {
  final repo = ref.watch(repositoriPesananProvider);
  return NotifierAdminPesanan(repo, ref);
});
