import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../inti/jaringan/hasil_api.dart';
import '../../data/model/kategori_model.dart';
import '../../data/model/produk_model.dart';
import '../../data/repositori/repositori_katalog.dart';

final repositoriKatalogProvider = Provider<RepositoriKatalog>((ref) {
  return RepositoriKatalog();
});

final idKategoriTerpilihProvider = StateProvider<int>((ref) => 1);

final kataKunciPencarianProvider = StateProvider<String>((ref) => '');

final daftarKategoriProvider = FutureProvider<List<KategoriModel>>((ref) async {
  final repo = ref.watch(repositoriKatalogProvider);
  final hasil = await repo.ambilKategori();
  if (hasil is ApiSukses<List<KategoriModel>>) {
    return hasil.data;
  }
  return [];
});

final daftarProdukProvider = FutureProvider<List<ProdukBungaModel>>((ref) async {
  final repo = ref.watch(repositoriKatalogProvider);
  final idKategori = ref.watch(idKategoriTerpilihProvider);
  final cari = ref.watch(kataKunciPencarianProvider);

  final hasil = await repo.ambilProduk(kategoriId: idKategori, cari: cari);
  if (hasil is ApiSukses<List<ProdukBungaModel>>) {
    return hasil.data;
  }
  return [];
});
