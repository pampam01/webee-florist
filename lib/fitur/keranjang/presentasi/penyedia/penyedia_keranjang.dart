import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/katalog_bunga/data/model/produk_model.dart';
import 'package:webee_florist/fitur/keranjang/data/model/item_keranjang_model.dart';
import 'package:webee_florist/fitur/keranjang/data/repositori/repositori_keranjang.dart';
import 'package:webee_florist/inti/jaringan/hasil_api.dart';

final repositoriKeranjangProvider = Provider<RepositoriKeranjang>((ref) {
  return RepositoriKeranjang();
});

class StateKeranjang {
  final List<ItemKeranjangModel> items;
  final bool sedangMemuat;
  final String? pesanKesalahan;

  const StateKeranjang({
    this.items = const [],
    this.sedangMemuat = false,
    this.pesanKesalahan,
  });

  double get totalHarga =>
      items.fold(0.0, (subtotal, item) => subtotal + item.subtotal);

  int get totalItem =>
      items.fold(0, (total, item) => total + item.kuantitas);

  StateKeranjang copyWith({
    List<ItemKeranjangModel>? items,
    bool? sedangMemuat,
    String? pesanKesalahan,
  }) {
    return StateKeranjang(
      items: items ?? this.items,
      sedangMemuat: sedangMemuat ?? this.sedangMemuat,
      pesanKesalahan: pesanKesalahan,
    );
  }
}

class NotifierKeranjang extends StateNotifier<StateKeranjang> {
  final RepositoriKeranjang _repositori;

  NotifierKeranjang(this._repositori) : super(const StateKeranjang()) {
    muatKeranjang();
  }

  Future<void> muatKeranjang() async {
    state = state.copyWith(sedangMemuat: true);
    final hasil = await _repositori.ambilKeranjang();
    if (hasil is ApiSukses<List<ItemKeranjangModel>>) {
      state = state.copyWith(items: hasil.data, sedangMemuat: false);
    } else if (hasil is ApiGagal<List<ItemKeranjangModel>>) {
      state = state.copyWith(
        sedangMemuat: false,
        pesanKesalahan: hasil.pesanKesalahan,
      );
    }
  }

  Future<bool> tambahProduk(ProdukBungaModel produk, {int kuantitas = 1, String? catatan}) async {
    final hasil = await _repositori.tambahItem(
      produk: produk,
      kuantitas: kuantitas,
      catatanKhusus: catatan,
    );
    if (hasil is ApiSukses<bool>) {
      await muatKeranjang();
      return true;
    }
    return false;
  }

  Future<void> perbaruiKuantitas(int itemId, int kuantitasBaru) async {
    if (kuantitasBaru <= 0) {
      await hapusItem(itemId);
      return;
    }
    await _repositori.ubahKuantitas(itemId: itemId, kuantitas: kuantitasBaru);
    await muatKeranjang();
  }

  Future<void> hapusItem(int itemId) async {
    await _repositori.hapusItem(itemId);
    await muatKeranjang();
  }

  Future<void> kosongkanKeranjang() async {
    await _repositori.bersihkanKeranjang();
    state = const StateKeranjang(items: []);
  }
}

final keranjangProvider =
    StateNotifierProvider<NotifierKeranjang, StateKeranjang>((ref) {
  final repo = ref.watch(repositoriKeranjangProvider);
  return NotifierKeranjang(repo);
});
