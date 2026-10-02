import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../inti/jaringan/hasil_api.dart';
import '../../../admin/presentasi/penyedia/penyedia_admin.dart';
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

// ==========================================
// PENYEDIA KHUSUS ADMIN KATALOG
// ==========================================

final kategoriFilterAdminProvider = StateProvider<int>((ref) => 0);
final pencarianKatalogAdminProvider = StateProvider<String>((ref) => '');

final daftarProdukAdminProvider = FutureProvider<List<ProdukBungaModel>>((ref) async {
  final repo = ref.watch(repositoriKatalogProvider);
  final idKategori = ref.watch(kategoriFilterAdminProvider);
  final cari = ref.watch(pencarianKatalogAdminProvider);

  final hasil = await repo.ambilSemuaProdukAdmin(
    kategoriId: idKategori,
    cari: cari,
  );
  if (hasil is ApiSukses<List<ProdukBungaModel>>) {
    return hasil.data;
  }
  return [];
});

class NotifierKatalogAdmin extends StateNotifier<bool> {
  final Ref _ref;
  NotifierKatalogAdmin(this._ref) : super(false);

  Future<List<String>?> unggahBanyakFoto(List<XFile> berkas) async {
    state = true;
    try {
      final repo = _ref.read(repositoriKatalogProvider);
      final hasil = await repo.unggahBanyakFoto(berkas);
      if (hasil is ApiSukses<List<String>>) {
        return hasil.data;
      }
      return null;
    } finally {
      state = false;
    }
  }

  Future<bool> tambahProduk(Map<String, dynamic> data) async {
    state = true;
    try {
      final repo = _ref.read(repositoriKatalogProvider);
      final hasil = await repo.tambahProduk(data);
      if (hasil is ApiSukses) {
        _segarkanSemua();
        return true;
      }
      return false;
    } finally {
      state = false;
    }
  }

  Future<bool> perbaruiProduk(int id, Map<String, dynamic> data) async {
    state = true;
    try {
      final repo = _ref.read(repositoriKatalogProvider);
      final hasil = await repo.perbaruiProduk(id, data);
      if (hasil is ApiSukses) {
        _segarkanSemua();
        return true;
      }
      return false;
    } finally {
      state = false;
    }
  }

  Future<bool> sesuaikanStok(int id, {int? perubahan, int? stokBaru, bool? apakahTersedia}) async {
    final repo = _ref.read(repositoriKatalogProvider);
    final hasil = await repo.sesuaikanStokCepat(
      id,
      perubahan: perubahan,
      stokBaru: stokBaru,
      apakahTersedia: apakahTersedia,
    );
    if (hasil is ApiSukses) {
      _segarkanSemua();
      return true;
    }
    return false;
  }

  Future<bool> ubahStatusTersedia(int id, bool statusTersedia) async {
    final repo = _ref.read(repositoriKatalogProvider);
    final hasil = await repo.sesuaikanStokCepat(
      id,
      apakahTersedia: statusTersedia,
    );
    if (hasil is ApiSukses) {
      _segarkanSemua();
      return true;
    }
    return false;
  }

  Future<bool> hapusProduk(int id) async {
    state = true;
    try {
      final repo = _ref.read(repositoriKatalogProvider);
      final hasil = await repo.hapusProduk(id);
      if (hasil is ApiSukses) {
        _segarkanSemua();
        return true;
      }
      return false;
    } finally {
      state = false;
    }
  }

  void _segarkanSemua() {
    _ref.invalidate(daftarProdukAdminProvider);
    _ref.invalidate(daftarProdukProvider);
    _ref.invalidate(ringkasanAdminProvider);
  }
}

final aksiKatalogAdminProvider = StateNotifierProvider<NotifierKatalogAdmin, bool>((ref) {
  return NotifierKatalogAdmin(ref);
});
