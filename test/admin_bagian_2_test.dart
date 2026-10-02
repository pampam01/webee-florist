import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webee_florist/fitur/admin/presentasi/widget/dialog_input_produk_bunga.dart';
import 'package:webee_florist/fitur/admin/presentasi/widget/tab_katalog_produk_admin.dart';
import 'package:webee_florist/fitur/katalog_bunga/data/model/kategori_model.dart';
import 'package:webee_florist/fitur/katalog_bunga/data/model/produk_model.dart';
import 'package:webee_florist/fitur/katalog_bunga/data/repositori/repositori_katalog.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/penyedia/penyedia_katalog.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/widget/slider_foto_bunga.dart';
import 'package:webee_florist/inti/jaringan/hasil_api.dart';

void main() {
  group('Admin Bagian 2 - Model & Repositori Katalog Bunga', () {
    test('ProdukBungaModel supports apakahUnggulan and copyWith', () {
      const model = ProdukBungaModel(
        id: 1,
        kategoriId: 2,
        nama: 'Royal Scarlet Velvet',
        slug: 'royal-scarlet-velvet',
        deskripsi: 'Mawar merah klasik',
        harga: 450000,
        stok: 12,
        urlGambar: 'https://example.com/flower.jpg',
        apakahTersedia: true,
        apakahUnggulan: true,
      );

      expect(model.id, 1);
      expect(model.apakahUnggulan, isTrue);
      expect(model.stok, 12);

      final diubah = model.copyWith(stok: 20, apakahUnggulan: false, harga: 480000);
      expect(diubah.stok, 20);
      expect(diubah.apakahUnggulan, isFalse);
      expect(diubah.harga, 480000);
      expect(diubah.nama, 'Royal Scarlet Velvet');
    });

    test('ProdukBungaModel supports galeriFoto and semuaFoto', () {
      final json = {
        'id': 5,
        'id_kategori': 2,
        'nama_bunga': 'Buket Rose Deluxe',
        'harga': 400000,
        'stok': 10,
        'gambar_url': 'https://example.com/cover.jpg',
        'foto_galeri': ['https://example.com/detail1.jpg', 'https://example.com/detail2.jpg'],
        'status_tersedia': true,
      };

      final model = ProdukBungaModel.fromJson(json);
      expect(model.galeriFoto.length, 2);
      expect(model.semuaFoto.length, 3);
      expect(model.semuaFoto.first, 'https://example.com/cover.jpg');
      expect(model.semuaFoto[1], 'https://example.com/detail1.jpg');
    });

    test('RepositoriKatalog handles admin catalog CRUD & quick stock adjustment', () async {
      final repo = RepositoriKatalog();

      // 1. Ambil katalog admin
      final hasilAwal = await repo.ambilSemuaProdukAdmin();
      expect(hasilAwal, isA<ApiSukses<List<ProdukBungaModel>>>());
      final awalList = (hasilAwal as ApiSukses<List<ProdukBungaModel>>).data;
      expect(awalList.isNotEmpty, isTrue);
      final countAwal = awalList.length;

      // 2. Tambah produk baru
      final hasilTambah = await repo.tambahProduk({
        'id_kategori': 2,
        'nama_bunga': 'Buket Lavender Parisian',
        'harga': 320000.0,
        'stok': 15,
        'deskripsi': 'Wangi lavender segar khas pedesaan Prancis Selatan.',
        'gambar_url': 'https://example.com/lavender.jpg',
        'foto_galeri': ['https://example.com/lavender_detail.jpg'],
        'apakah_unggulan': true,
        'status_tersedia': true,
      });
      expect(hasilTambah, isA<ApiSukses<ProdukBungaModel>>());
      final produkBaru = (hasilTambah as ApiSukses<ProdukBungaModel>).data;
      expect(produkBaru.nama, 'Buket Lavender Parisian');
      expect(produkBaru.apakahUnggulan, isTrue);
      expect(produkBaru.galeriFoto.length, 1);

      // Verifikasi bertambah
      final hasilSetelahTambah = await repo.ambilSemuaProdukAdmin();
      final listSetelahTambah = (hasilSetelahTambah as ApiSukses<List<ProdukBungaModel>>).data;
      expect(listSetelahTambah.length, countAwal + 1);

      // 3. Sesuaikan stok cepat (+5)
      final hasilStok = await repo.sesuaikanStokCepat(produkBaru.id, perubahan: 5);
      expect(hasilStok, isA<ApiSukses<bool>>());

      final hasilCekStok = await repo.ambilSemuaProdukAdmin(cari: 'Lavender Parisian');
      final listCek = (hasilCekStok as ApiSukses<List<ProdukBungaModel>>).data;
      expect(listCek.first.stok, 20);

      // 4. Ubah ketersediaan
      final hasilTersedia = await repo.sesuaikanStokCepat(produkBaru.id, apakahTersedia: false);
      expect(hasilTersedia, isA<ApiSukses<bool>>());

      // 5. Hapus produk
      final hasilHapus = await repo.hapusProduk(produkBaru.id);
      expect(hasilHapus, isA<ApiSukses<bool>>());

      final hasilSetelahHapus = await repo.ambilSemuaProdukAdmin();
      final listSetelahHapus = (hasilSetelahHapus as ApiSukses<List<ProdukBungaModel>>).data;
      expect(listSetelahHapus.length, countAwal);
    });

    test('RepositoriKatalog unggahBanyakFoto handles fallback in local test mode', () async {
      final repo = RepositoriKatalog();
      final berkasMock = [XFile.fromData(Uint8List.fromList([1, 2, 3]), name: 'foto_bunga_test.jpg')];
      final hasil = await repo.unggahBanyakFoto(berkasMock);
      expect(hasil, isA<ApiSukses<List<String>>>());
      expect((hasil as ApiSukses<List<String>>).data.isNotEmpty, isTrue);
    });
  });

  group('Admin Bagian 2 - Widget Tests', () {
    testWidgets('SliderFotoBunga renders PageView and indicators for multiple photos', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SliderFotoBunga(
              daftarFoto: [
                'https://example.com/foto1.jpg',
                'https://example.com/foto2.jpg',
              ],
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(PageView), findsOneWidget);
      expect(find.text('1/2'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
    });

    testWidgets('TabKatalogProdukAdmin renders header, mini stats, search bar, and action button', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));

      final mockProduk = [
        const ProdukBungaModel(
          id: 1,
          kategoriId: 2,
          nama: 'Royal Scarlet Velvet Bouquet',
          slug: 'royal-scarlet-velvet',
          deskripsi: 'Mawar merah klasik',
          harga: 450000,
          stok: 12,
          urlGambar: 'https://example.com/flower.jpg',
          apakahTersedia: true,
          apakahUnggulan: true,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            daftarProdukAdminProvider.overrideWith((ref) async => mockProduk),
            daftarKategoriProvider.overrideWith((ref) async => const [
                  KategoriModel(id: 1, nama: 'Semua Koleksi', slug: 'semua'),
                  KategoriModel(id: 2, nama: 'Buket Mawar', slug: 'buket-mawar'),
                ]),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: TabKatalogProdukAdmin(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verifikasi Header & Tombol Tambah
      expect(find.text('Manajemen Katalog & Koleksi Bunga'), findsOneWidget);
      expect(find.text('Tambah Bunga Baru'), findsOneWidget);

      // Verifikasi Mini Statistik KPI
      expect(find.text('Total Varian'), findsOneWidget);
      expect(find.text('Stok Menipis (<5)'), findsOneWidget);
      expect(find.text('Koleksi Unggulan'), findsOneWidget);
      expect(find.text('Kondisi Tersedia'), findsOneWidget);

      // Verifikasi Tabel Kolom Desktop
      expect(find.text('Karya Rangkaian & Kategori'), findsOneWidget);
      expect(find.text('Harga Atelier'), findsOneWidget);
      expect(find.text('Stok Kuntum'), findsOneWidget);
      expect(find.text('Ketersediaan'), findsOneWidget);
      expect(find.text('Tindakan'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('DialogInputProdukBunga renders multi-photo upload and form elements', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            daftarKategoriProvider.overrideWith((ref) async => const [
                  KategoriModel(id: 2, nama: 'Buket Mawar', slug: 'buket-mawar'),
                  KategoriModel(id: 3, nama: 'Buket Lily', slug: 'buket-lily'),
                ]),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DialogInputProdukBunga(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verifikasi Elemen Form Tambah & Multi-Foto
      expect(find.text('Tambah Rangkaian Bunga Baru'), findsOneWidget);
      expect(find.text('Nama Rangkaian Bunga *'), findsOneWidget);
      expect(find.text('Kategori Bunga *'), findsOneWidget);
      expect(find.text('Harga Rangkaian (Rp) *'), findsOneWidget);
      expect(find.text('Stok Tersedia (Unit) *'), findsOneWidget);
      expect(find.text('Galeri Foto Rangkaian Bunga (Bisa Banyak Foto)'), findsOneWidget);
      expect(find.text('Unggah dari Perangkat'), findsOneWidget);
      expect(find.text('Koleksi Unggulan (Atelier Signature)'), findsOneWidget);
      expect(find.text('Status Ketersediaan Bunga'), findsOneWidget);
      expect(find.text('Tambah ke Koleksi'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });
  });
}
