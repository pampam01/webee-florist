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
  }
}

final buatPesananProvider =
    StateNotifierProvider<NotifierBuatPesanan, StateBuatPesanan>((ref) {
  final repo = ref.watch(repositoriPesananProvider);
  return NotifierBuatPesanan(repo, ref);
});
