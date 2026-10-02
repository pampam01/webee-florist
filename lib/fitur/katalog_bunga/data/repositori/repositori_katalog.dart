import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../inti/jaringan/hasil_api.dart';
import '../../../../inti/jaringan/klien_api.dart';
import '../../../../inti/konstanta/konstanta_api.dart';
import '../model/kategori_model.dart';
import '../model/produk_model.dart';

class RepositoriKatalog {
  final Dio _dio = KlienApi.instance;

  // Data Mock Offline Mewah jika server belum dijalankan
  static final List<KategoriModel> _mockKategori = [
    const KategoriModel(id: 1, nama: 'Semua Koleksi', slug: 'semua', ikon: null),
    const KategoriModel(id: 2, nama: 'Buket Mawar', slug: 'buket-mawar', ikon: null),
    const KategoriModel(id: 3, nama: 'Buket Lily', slug: 'buket-lily', ikon: null),
    const KategoriModel(id: 4, nama: 'Bunga Meja & Vas', slug: 'bunga-meja', ikon: null),
    const KategoriModel(id: 5, nama: 'Buket Wisuda', slug: 'bunga-wisuda', ikon: null),
    const KategoriModel(id: 6, nama: 'Bunga Papan Ucapan', slug: 'bunga-papan', ikon: null),
  ];

  static final List<ProdukBungaModel> _mockProduk = [
    const ProdukBungaModel(
      id: 1,
      kategoriId: 2,
      nama: 'Royal Velvet Red Roses (24 Tangkai)',
      slug: 'royal-velvet-red-roses',
      deskripsi: 'Buket mawar merah premium impor grade A dengan pita satin emas mewah.',
      harga: 450000,
      stok: 15,
      urlGambar: 'https://images.unsplash.com/photo-1561181286-d3fee7d55364?auto=format&fit=crop&w=600&q=80',
      apakahTersedia: true,
    ),
    const ProdukBungaModel(
      id: 2,
      kategoriId: 2,
      nama: 'Blushing Pink Romance Bouquet',
      slug: 'blushing-pink-romance',
      deskripsi: 'Kombinasi mawar pink pastel lembut dengan sentuhan baby breath putih anggun.',
      harga: 375000,
      stok: 20,
      urlGambar: 'https://images.unsplash.com/photo-1526047932273-341f2a7631f9?auto=format&fit=crop&w=600&q=80',
      apakahTersedia: true,
    ),
    const ProdukBungaModel(
      id: 3,
      kategoriId: 3,
      nama: 'White Casablanca Imperial Lily',
      slug: 'white-casablanca-imperial-lily',
      deskripsi: 'Bunga lily putih harum semerbak nan megah, melambangkan kemurnian cinta.',
      harga: 520000,
      stok: 8,
      urlGambar: 'https://images.unsplash.com/photo-1533616688419-b7a585564566?auto=format&fit=crop&w=600&q=80',
      apakahTersedia: true,
    ),
    const ProdukBungaModel(
      id: 4,
      kategoriId: 4,
      nama: 'Emerald Golden Table Floral Arrangement',
      slug: 'emerald-golden-table-arrangement',
      deskripsi: 'Rangkaian bunga meja mewah dalam vas keramik eksklusif untuk ruang tamu & rapat.',
      harga: 650000,
      stok: 5,
      urlGambar: 'https://images.unsplash.com/photo-1508610048659-a06b669e3321?auto=format&fit=crop&w=600&q=80',
      apakahTersedia: true,
    ),
    const ProdukBungaModel(
      id: 5,
      kategoriId: 5,
      nama: 'Sunflower Sunburst Graduation Bouquet',
      slug: 'sunflower-sunburst-graduation',
      deskripsi: 'Bunga matahari cerah melambangkan kesuksesan dan harapan masa depan cerah.',
      harga: 280000,
      stok: 25,
      urlGambar: 'https://images.unsplash.com/photo-1470509037663-253afd7f0f51?auto=format&fit=crop&w=600&q=80',
      apakahTersedia: true,
    ),
    const ProdukBungaModel(
      id: 6,
      kategoriId: 6,
      nama: 'Everlasting Eternal Preserved Glass Dome',
      slug: 'everlasting-eternal-glass-dome',
      deskripsi: 'Mawar abadi yang diawetkan dalam kubah kaca kristal dengan lampu fairy LED.',
      harga: 750000,
      stok: 10,
      urlGambar: 'https://images.unsplash.com/photo-1518895949257-7621c3c786d7?auto=format&fit=crop&w=600&q=80',
      apakahTersedia: true,
    ),
  ];

  Future<HasilApi<List<KategoriModel>>> ambilKategori() async {
    try {
      final respon = await _dio.get(KonstantaApi.kategori);
      if (respon.statusCode == 200 && respon.data['sukses'] == true) {
        final listJson = respon.data['data'] as List;
        final hasil = listJson.map((e) => KategoriModel.fromJson(e)).toList();
        return ApiSukses(hasil);
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal memuat kategori');
    } catch (_) {
      return ApiSukses(_mockKategori, pesan: 'Mode Lokal Terhubung');
    }
  }

  Future<HasilApi<List<ProdukBungaModel>>> ambilProduk({
    int? kategoriId,
    String? cari,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (kategoriId != null && kategoriId > 1) {
        query['kategori_id'] = kategoriId;
      }
      if (cari != null && cari.isNotEmpty) {
        query['cari'] = cari;
      }

      final respon = await _dio.get(KonstantaApi.produk, queryParameters: query);
      if (respon.statusCode == 200 && respon.data['sukses'] == true) {
        final listJson = respon.data['data'] as List;
        final hasil = listJson.map((e) => ProdukBungaModel.fromJson(e)).toList();
        return ApiSukses(hasil);
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal memuat produk');
    } catch (_) {
      var hasil = _mockProduk;
      if (kategoriId != null && kategoriId > 1) {
        hasil = hasil.where((p) => p.kategoriId == kategoriId).toList();
      }
      if (cari != null && cari.isNotEmpty) {
        final q = cari.toLowerCase();
        hasil = hasil.where((p) => p.nama.toLowerCase().contains(q) || p.deskripsi.toLowerCase().contains(q)).toList();
      }
      return ApiSukses(hasil, pesan: 'Mode Lokal Terhubung');
    }
  }

  Future<HasilApi<List<ProdukBungaModel>>> ambilSemuaProdukAdmin({
    int? kategoriId,
    String? cari,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (kategoriId != null && kategoriId > 0) {
        query['kategori_id'] = kategoriId;
      }
      if (cari != null && cari.isNotEmpty) {
        query['cari'] = cari;
      }

      final respon = await _dio.get(KonstantaApi.adminProduk, queryParameters: query);
      if (respon.statusCode == 200 && respon.data['sukses'] == true) {
        final listJson = respon.data['data'] as List;
        final hasil = listJson.map((e) => ProdukBungaModel.fromJson(e)).toList();
        return ApiSukses(hasil);
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal memuat katalog admin');
    } catch (_) {
      // Cadangan: Ambil dari endpoint katalog umum jika ada kendala rute admin
      try {
        final query = <String, dynamic>{};
        if (kategoriId != null && kategoriId > 0) {
          query['kategori_id'] = kategoriId;
        }
        if (cari != null && cari.isNotEmpty) {
          query['cari'] = cari;
        }
        final responPublik = await _dio.get(KonstantaApi.produk, queryParameters: query);
        if (responPublik.statusCode == 200 && responPublik.data['sukses'] == true) {
          final listJson = responPublik.data['data'] as List;
          final hasil = listJson.map((e) => ProdukBungaModel.fromJson(e)).toList();
          return ApiSukses(hasil);
        }
      } catch (_) {}

      var hasil = List<ProdukBungaModel>.from(_mockProduk);
      if (kategoriId != null && kategoriId > 0) {
        hasil = hasil.where((p) => p.kategoriId == kategoriId).toList();
      }
      if (cari != null && cari.isNotEmpty) {
        final q = cari.toLowerCase();
        hasil = hasil.where((p) => p.nama.toLowerCase().contains(q) || p.deskripsi.toLowerCase().contains(q)).toList();
      }
      return ApiSukses(hasil, pesan: 'Mode Lokal Terhubung');
    }
  }

  Future<HasilApi<List<String>>> unggahBanyakFoto(List<XFile> daftarBerkas) async {
    try {
      final formData = FormData();
      for (final berkas in daftarBerkas) {
        final bytes = await berkas.readAsBytes();
        formData.files.add(MapEntry(
          'berkas[]',
          MultipartFile.fromBytes(bytes, filename: berkas.name),
        ));
      }

      final respon = await _dio.post(
        KonstantaApi.unggahFoto,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      if (respon.statusCode == 200 && respon.data['sukses'] == true) {
        final list = (respon.data['data'] as List).map((e) => e.toString()).toList();
        return ApiSukses(list, pesan: respon.data['pesan']?.toString() ?? 'Foto berhasil diunggah');
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal mengunggah foto');
    } catch (_) {
      final mock = daftarBerkas
          .map((b) => 'http://127.0.0.1:8000/unggah/produk/local_${b.name}')
          .toList();
      return ApiSukses(mock, pesan: 'Foto tersimpan secara simulasi lokal.');
    }
  }

  Future<HasilApi<ProdukBungaModel>> tambahProduk(Map<String, dynamic> data) async {
    try {
      final respon = await _dio.post(KonstantaApi.produk, data: data);
      if (respon.statusCode == 201 && respon.data['sukses'] == true) {
        return ApiSukses(ProdukBungaModel.fromJson(respon.data['data']));
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal menambahkan produk');
    } catch (_) {
      final idBaru = DateTime.now().millisecondsSinceEpoch % 10000;
      final baru = ProdukBungaModel(
        id: idBaru,
        kategoriId: data['id_kategori'] ?? 1,
        nama: data['nama_bunga'] ?? 'Buket Bunga Baru',
        slug: 'buket-bunga-$idBaru',
        deskripsi: data['deskripsi'] ?? '',
        harga: double.tryParse(data['harga'].toString()) ?? 150000.0,
        stok: int.tryParse(data['stok'].toString()) ?? 10,
        urlGambar: data['gambar_url'] ?? '',
        galeriFoto: (data['foto_galeri'] is List) ? List<String>.from(data['foto_galeri']) : [],
        apakahUnggulan: data['apakah_unggulan'] == true,
        apakahTersedia: data['status_tersedia'] != false,
      );
      _mockProduk.insert(0, baru);
      return ApiSukses(baru, pesan: 'Produk berhasil ditambahkan (Mode Pengembang)');
    }
  }

  Future<HasilApi<bool>> perbaruiProduk(int id, Map<String, dynamic> data) async {
    try {
      final respon = await _dio.put('${KonstantaApi.produk}/$id', data: data);
      if (respon.statusCode == 200) {
        _sinkronkanMockUpdate(id, data);
        return const ApiSukses(true);
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal memperbarui produk');
    } catch (_) {
      _sinkronkanMockUpdate(id, data);
      return const ApiSukses(true);
    }
  }

  Future<HasilApi<bool>> sesuaikanStokCepat(
    int id, {
    int? perubahan,
    int? stokBaru,
    bool? apakahTersedia,
  }) async {
    final payload = <String, dynamic>{};
    if (perubahan != null) payload['perubahan'] = perubahan;
    if (stokBaru != null) payload['stok_baru'] = stokBaru;
    if (apakahTersedia != null) payload['status_tersedia'] = apakahTersedia;

    try {
      final respon = await _dio.patch('${KonstantaApi.produk}/$id/stok', data: payload);
      if (respon.statusCode == 200) {
        _sinkronkanMockStok(id, perubahan: perubahan, stokBaru: stokBaru, apakahTersedia: apakahTersedia);
        return const ApiSukses(true);
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal menyesuaikan stok');
    } catch (_) {
      _sinkronkanMockStok(id, perubahan: perubahan, stokBaru: stokBaru, apakahTersedia: apakahTersedia);
      return const ApiSukses(true);
    }
  }

  Future<HasilApi<bool>> hapusProduk(int id) async {
    try {
      final respon = await _dio.delete('${KonstantaApi.produk}/$id');
      if (respon.statusCode == 200) {
        _mockProduk.removeWhere((p) => p.id == id);
        return const ApiSukses(true);
      }
      return ApiGagal(respon.data['pesan'] ?? 'Gagal menghapus produk');
    } catch (_) {
      _mockProduk.removeWhere((p) => p.id == id);
      return const ApiSukses(true);
    }
  }

  void _sinkronkanMockUpdate(int id, Map<String, dynamic> data) {
    final idx = _mockProduk.indexWhere((p) => p.id == id);
    if (idx >= 0) {
      _mockProduk[idx] = _mockProduk[idx].copyWith(
        nama: data['nama_bunga'] ?? _mockProduk[idx].nama,
        kategoriId: data['id_kategori'] ?? _mockProduk[idx].kategoriId,
        harga: data['harga'] != null ? double.tryParse(data['harga'].toString()) : _mockProduk[idx].harga,
        stok: data['stok'] != null ? int.tryParse(data['stok'].toString()) : _mockProduk[idx].stok,
        deskripsi: data['deskripsi'] ?? _mockProduk[idx].deskripsi,
        urlGambar: data['gambar_url'] ?? _mockProduk[idx].urlGambar,
        galeriFoto: data['foto_galeri'] != null && data['foto_galeri'] is List
            ? List<String>.from(data['foto_galeri'])
            : _mockProduk[idx].galeriFoto,
        apakahUnggulan: data['apakah_unggulan'] ?? _mockProduk[idx].apakahUnggulan,
        apakahTersedia: data['status_tersedia'] ?? _mockProduk[idx].apakahTersedia,
      );
    }
  }

  void _sinkronkanMockStok(int id, {int? perubahan, int? stokBaru, bool? apakahTersedia}) {
    final idx = _mockProduk.indexWhere((p) => p.id == id);
    if (idx >= 0) {
      int s = _mockProduk[idx].stok;
      if (stokBaru != null) {
        s = stokBaru;
      } else if (perubahan != null) {
        s = (s + perubahan).clamp(0, 9999);
      }

      bool k = apakahTersedia ?? _mockProduk[idx].apakahTersedia;
      if (s == 0 && apakahTersedia == null) {
        k = false;
      }

      _mockProduk[idx] = _mockProduk[idx].copyWith(stok: s, apakahTersedia: k);
    }
  }
}
