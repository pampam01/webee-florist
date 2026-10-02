import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/fitur/katalog_bunga/data/model/kategori_model.dart';
import 'package:webee_florist/fitur/katalog_bunga/data/model/produk_model.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/halaman/halaman_detail_produk.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/halaman/halaman_katalog_bunga.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/penyedia/penyedia_katalog.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/widget/dialog_pratinjau_foto_zoom.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/widget/slider_foto_bunga.dart';

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;
  @override
  Duration? connectionTimeout;
  @override
  Duration idleTimeout = const Duration(seconds: 15);
  @override
  int? maxConnectionsPerHost;
  @override
  String? userAgent;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async => _MockHttpClientRequest();
}

class _MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();
  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
}

class _MockHttpHeaders extends Fake implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => kTransparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(kTransparentImage).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

final Uint8List kTransparentImage = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
]);

void main() {
  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  tearDown(() {
    HttpOverrides.global = null;
  });

  const dummyProduk = ProdukBungaModel(
    id: 101,
    kategoriId: 2,
    nama: 'Buket Mawar Merah Mon Amour',
    slug: 'buket-mawar-merah-mon-amour',
    deskripsi: 'Rangkaian mawar merah segar dengan pembungkus satin mewah.',
    harga: 350000,
    stok: 12,
    urlGambar: 'https://images.unsplash.com/photo-1561181286-d3fee7d55364',
    galeriFoto: [
      'https://images.unsplash.com/photo-1561181286-d3fee7d55364',
      'https://images.unsplash.com/photo-1526047932273-341f2a7631f9',
    ],
    apakahTersedia: true,
  );

  testWidgets('SliderFotoBunga menampilkan multi foto, tombol zoom, dan indikator', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SliderFotoBunga(
            daftarFoto: [
              'https://images.unsplash.com/photo-1561181286-d3fee7d55364',
              'https://images.unsplash.com/photo-1526047932273-341f2a7631f9',
            ],
            bisaDiKlikZoom: true,
            judulProduk: 'Buket Mawar Merah',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Perbesar'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget);

    // Ketuk tombol Perbesar
    await tester.tap(find.text('Perbesar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verifikasi Dialog Pratinjau Zoom terbuka dengan InteractiveViewer
    expect(find.byType(DialogPratinjauFotoZoom), findsOneWidget);
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.text('Buket Mawar Merah'), findsOneWidget);

    // Tutup dialog
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(DialogPratinjauFotoZoom), findsNothing);
  });

  testWidgets('HalamanDetailProduk menampilkan layout mobile dengan sticky bottom bar', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HalamanDetailProduk(produk: dummyProduk),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verifikasi elemen teks produk hadir
    expect(find.text('Détail Bouquet'), findsOneWidget);
    expect(find.text('Buket Mawar Merah Mon Amour'), findsOneWidget);
    expect(find.text('Rp 350.000'), findsWidgets);
    expect(find.text('Total Pesanan'), findsOneWidget);
    expect(find.text('+ Keranjang'), findsOneWidget);
  });

  testWidgets('HalamanDetailProduk menampilkan layout desktop atelier dua kolom', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HalamanDetailProduk(produk: dummyProduk),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verifikasi elemen desktop atelier
    expect(find.text('Katalog Bunga'), findsOneWidget);
    expect(find.text('Beli Sekarang'), findsOneWidget);
    expect(find.text('Tambah ke Keranjang'), findsOneWidget);
    expect(find.text('Filosofi & Komposisi Rangkaian'), findsOneWidget);
  });

  testWidgets('HalamanKatalogBunga menampilkan header pencarian, kategori, dan grid produk', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          daftarKategoriProvider.overrideWith((ref) => Future.value([
                const KategoriModel(id: 1, nama: 'Semua Koleksi', slug: 'semua', ikon: null),
                const KategoriModel(id: 2, nama: 'Buket Mawar', slug: 'buket-mawar', ikon: null),
              ])),
          daftarProdukProvider.overrideWith((ref) => Future.value([dummyProduk])),
        ],
        child: const MaterialApp(
          home: HalamanKatalogBunga(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.pump();

    // Verifikasi elemen header & judul katalog
    expect(find.text('Koleksi Seni Merangkai Bunga'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Semua Koleksi'), findsOneWidget);
    expect(find.text('Tersedia Saja'), findsOneWidget);
    expect(find.text('Buket Mawar Merah Mon Amour'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 500));
  });
}
