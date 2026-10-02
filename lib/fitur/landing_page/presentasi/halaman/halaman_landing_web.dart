import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/fitur/autentikasi/presentasi/penyedia/penyedia_autentikasi.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/halaman/halaman_katalog_bunga.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/penyedia/penyedia_katalog.dart';
import 'package:webee_florist/fitur/keranjang/presentasi/penyedia/penyedia_keranjang.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';
import '../widget/bilah_navigasi_atas.dart';
import '../widget/dialog_masuk_cepat.dart';
import '../widget/kaki_halaman_web.dart';
import '../widget/laci_keranjang_web.dart';
import '../widget/seksi_cerita_florist.dart';
import '../widget/seksi_hero.dart';
import '../widget/seksi_kategori.dart';
import '../widget/seksi_keunggulan.dart';
import '../widget/seksi_produk_unggulan.dart';
import '../widget/seksi_ulasan.dart';

class HalamanLandingWeb extends ConsumerStatefulWidget {
  const HalamanLandingWeb({super.key});

  @override
  ConsumerState<HalamanLandingWeb> createState() => _HalamanLandingWebState();
}

class _HalamanLandingWebState extends ConsumerState<HalamanLandingWeb> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _kunciHero = GlobalKey();
  final GlobalKey _kunciKategori = GlobalKey();
  final GlobalKey _kunciKatalog = GlobalKey();
  final GlobalKey _kunciCerita = GlobalKey();
  final GlobalKey _kunciKeunggulan = GlobalKey();
  final GlobalKey _kunciUlasan = GlobalKey();
  final GlobalKey _kunciKontak = GlobalKey();

  void _gulirKeSeksi(int indeks) {
    GlobalKey targetKunci;
    switch (indeks) {
      case 0:
        targetKunci = _kunciHero;
        break;
      case 1:
        targetKunci = _kunciKategori;
        break;
      case 2:
        targetKunci = _kunciKatalog;
        break;
      case 3:
        targetKunci = _kunciCerita;
        break;
      case 4:
        targetKunci = _kunciKeunggulan;
        break;
      case 5:
        targetKunci = _kunciUlasan;
        break;
      case 6:
        targetKunci = _kunciKontak;
        break;
      default:
        targetKunci = _kunciHero;
    }

    final contextTarget = targetKunci.currentContext;
    if (contextTarget != null) {
      Scrollable.ensureVisible(
        contextTarget,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateAuth = ref.watch(autentikasiProvider);

    return Scaffold(
      backgroundColor: WarnaAplikasi.latarBelakang,
      // Laci Menu untuk Tampilan Ponsel (Mobile Drawer)
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/logo/logo_webee_horizontal.png',
                      height: 38,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Text(
                        'Webee Florist',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: WarnaAplikasi.utama,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    _itemDrawer(Icons.home_outlined, 'Beranda', () {
                      Navigator.of(context).pop();
                      _gulirKeSeksi(0);
                    }),
                    _itemDrawer(Icons.spa_outlined, 'Koleksi Bunga', () {
                      Navigator.of(context).pop();
                      _gulirKeSeksi(1);
                    }),
                    _itemDrawer(Icons.grid_view_outlined, 'Katalog Produk', () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HalamanKatalogBunga()),
                      );
                    }),
                    _itemDrawer(Icons.auto_stories_outlined, 'Filosofi Florist', () {
                      Navigator.of(context).pop();
                      _gulirKeSeksi(3);
                    }),
                    _itemDrawer(Icons.verified_outlined, 'Keunggulan Kami', () {
                      Navigator.of(context).pop();
                      _gulirKeSeksi(4);
                    }),
                    _itemDrawer(Icons.star_outline_rounded, 'Ulasan Pelanggan', () {
                      Navigator.of(context).pop();
                      _gulirKeSeksi(5);
                    }),
                    _itemDrawer(Icons.location_on_outlined, 'Kontak & Lokasi', () {
                      Navigator.of(context).pop();
                      _gulirKeSeksi(6);
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: stateAuth.sudahMasuk
                    ? OutlinedButton.icon(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await ref.read(autentikasiProvider.notifier).keluar();
                        },
                        icon: const Icon(Icons.logout, size: 16),
                        label: const Text('Keluar dari Akun'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          DialogMasukCepat.tampilkan(context);
                        },
                        child: const Text('Masuk ke Akun'),
                      ),
              ),
            ],
          ),
        ),
      ),

      // Badan Halaman Utama Web
      body: SafeArea(
        child: Column(
          children: [
            // Bilah Navigasi Atas Web (Sticky Header)
            BilahNavigasiAtas(
              padaPilihSeksi: _gulirKeSeksi,
            ),

            // Konten Gulir Panjang Landing Page
            Expanded(
              child: RefreshIndicator(
                color: WarnaAplikasi.utama,
                onRefresh: () async {
                  ref.invalidate(daftarProdukProvider);
                  ref.invalidate(daftarKategoriProvider);
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // 1. Seksi Hero
                      Container(
                        key: _kunciHero,
                        child: SeksiHero(
                          padaJelajahiKatalog: () => _gulirKeSeksi(2),
                          padaHubungiWhatsapp: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Menghubungkan ke WhatsApp Konsultasi Florist: +62 812-9876-5432'),
                                backgroundColor: WarnaAplikasi.utama,
                              ),
                            );
                          },
                        ),
                      ),

                      // 2. Seksi Kategori Pilihan
                      Container(
                        key: _kunciKategori,
                        child: SeksiKategori(
                          padaPilihKategori: (id) {
                            ref.read(idKategoriTerpilihProvider.notifier).state = id;
                            _gulirKeSeksi(2);
                          },
                        ),
                      ),

                      // 3. Seksi Produk Unggulan (Data Langsung MySQL)
                      Container(
                        key: _kunciKatalog,
                        child: const SeksiProdukUnggulan(),
                      ),

                      // 4. Seksi Cerita & Filosofi Florist Utiy
                      Container(
                        key: _kunciCerita,
                        child: const SeksiCeritaFlorist(),
                      ),

                      // 5. Seksi 4 Keunggulan Layanan
                      Container(
                        key: _kunciKeunggulan,
                        child: const SeksiKeunggulan(),
                      ),

                      // 6. Seksi Ulasan & Kisah Pelanggan
                      Container(
                        key: _kunciUlasan,
                        child: const SeksiUlasan(),
                      ),

                      // 7. Kaki Halaman Web (Footer)
                      Container(
                        key: _kunciKontak,
                        child: KakiHalamanWeb(
                          padaPilihSeksi: _gulirKeSeksi,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Tombol Keranjang Melayang Cepat untuk Layar Ponsel
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          final lebar = MediaQuery.of(context).size.width;
          if (lebar >= 960) return const SizedBox.shrink();

          final totalItem = ref.watch(keranjangProvider).totalItem;
          return FloatingActionButton.extended(
            backgroundColor: WarnaAplikasi.utama,
            foregroundColor: Colors.white,
            onPressed: () => LaciKeranjangWeb.buka(context),
            icon: Badge(
              isLabelVisible: totalItem > 0,
              backgroundColor: WarnaAplikasi.aksenEmas,
              label: Text('$totalItem'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            label: const Text('Keranjang Belanja'),
          );
        },
      ),
    );
  }

  Widget _itemDrawer(IconData ikon, String judul, VoidCallback padaTekan) {
    return ListTile(
      leading: Icon(ikon, color: WarnaAplikasi.utama, size: 20),
      title: Text(
        judul,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: WarnaAplikasi.teksUtama,
        ),
      ),
      onTap: padaTekan,
    );
  }
}
