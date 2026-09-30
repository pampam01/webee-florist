import 'package:dio/dio.dart';
import 'package:webee_florist/fitur/katalog_bunga/data/model/produk_model.dart';
import 'package:webee_florist/fitur/keranjang/data/model/item_keranjang_model.dart';
import 'package:webee_florist/inti/jaringan/hasil_api.dart';
import 'package:webee_florist/inti/jaringan/klien_api.dart';
import 'package:webee_florist/inti/konstanta/konstanta_api.dart';

class RepositoriKeranjang {
  final Dio _dio = KlienApi.instance;

  // In-memory fallback keranjang untuk demonstrasi instan saat offline
  static final List<ItemKeranjangModel> _keranjangLokal = [
    const ItemKeranjangModel(
      id: 101,
      penggunaId: 1,
      produkId: 1,
      kuantitas: 1,
      catatanKhusus: 'Pita warna emas elegan',
      produk: ProdukBungaModel(
        id: 1,
        kategoriId: 2,
        nama: 'Royal Velvet Red Roses (24 Tangkai)',
        slug: 'royal-velvet-red-roses',
        deskripsi: 'Buket mawar merah premium impor grade A dengan pita satin emas mewah.',
        harga: 450000,
        stok: 15,
        urlGambar: 'https://images.unsplash.com/photo-1561181286-d3fee7d55364?auto=format&fit=crop&w=600&q=80',
      ),
    ),
  ];

  Future<HasilApi<List<ItemKeranjangModel>>> ambilKeranjang() async {
    try {
      final respon = await _dio.get(KonstantaApi.keranjang);
      if (respon.statusCode == 200 && respon.data['sukses'] == true) {
        final listJson = respon.data['data'] as List;
        final list = listJson.map((e) => ItemKeranjangModel.fromJson(e)).toList();
        return ApiSukses(list);
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal memuat keranjang');
    } catch (_) {
      return ApiSukses(List.from(_keranjangLokal));
    }
  }

  Future<HasilApi<bool>> tambahItem({
    required ProdukBungaModel produk,
    int kuantitas = 1,
    String? catatanKhusus,
  }) async {
    try {
      final respon = await _dio.post(
        KonstantaApi.keranjang,
        data: {
          'produk_id': produk.id,
          'kuantitas': kuantitas,
          'catatan_khusus': catatanKhusus,
        },
      );
      if (respon.statusCode == 200 || respon.statusCode == 201) {
        return const ApiSukses(true, pesan: 'Berhasil ditambahkan ke keranjang');
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal menambah item');
    } catch (_) {
      final index = _keranjangLokal.indexWhere((it) => it.produkId == produk.id);
      if (index >= 0) {
        final itemLama = _keranjangLokal[index];
        _keranjangLokal[index] = itemLama.copyWith(kuantitas: itemLama.kuantitas + kuantitas);
      } else {
        _keranjangLokal.add(
          ItemKeranjangModel(
            id: DateTime.now().millisecondsSinceEpoch,
            penggunaId: 1,
            produkId: produk.id,
            kuantitas: kuantitas,
            catatanKhusus: catatanKhusus,
            produk: produk,
          ),
        );
      }
      return const ApiSukses(true, pesan: 'Berhasil dimasukkan ke keranjang');
    }
  }

  Future<HasilApi<bool>> ubahKuantitas({
    required int itemId,
    required int kuantitas,
  }) async {
    try {
      final respon = await _dio.put(
        '${KonstantaApi.keranjang}/$itemId',
        data: {'kuantitas': kuantitas},
      );
      if (respon.statusCode == 200) {
        return const ApiSukses(true);
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal mengubah kuantitas');
    } catch (_) {
      final index = _keranjangLokal.indexWhere((it) => it.id == itemId);
      if (index >= 0) {
        if (kuantitas <= 0) {
          _keranjangLokal.removeAt(index);
        } else {
          _keranjangLokal[index] = _keranjangLokal[index].copyWith(kuantitas: kuantitas);
        }
      }
      return const ApiSukses(true);
    }
  }

  Future<HasilApi<bool>> hapusItem(int itemId) async {
    try {
      final respon = await _dio.delete('${KonstantaApi.keranjang}/$itemId');
      if (respon.statusCode == 200) {
        return const ApiSukses(true);
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal menghapus item');
    } catch (_) {
      _keranjangLokal.removeWhere((it) => it.id == itemId);
      return const ApiSukses(true);
    }
  }

  Future<HasilApi<bool>> bersihkanKeranjang() async {
    try {
      await _dio.delete(KonstantaApi.bersihkanKeranjang);
      return const ApiSukses(true);
    } catch (_) {
      _keranjangLokal.clear();
      return const ApiSukses(true);
    }
  }
}
