import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/fitur/admin/presentasi/penyedia/penyedia_admin.dart';
import 'package:webee_florist/fitur/admin/presentasi/widget/bilah_sisi_admin.dart';
import 'package:webee_florist/fitur/admin/presentasi/widget/tab_katalog_produk_admin.dart';
import 'package:webee_florist/fitur/admin/presentasi/widget/tab_pesanan_transaksi_admin.dart';
import 'package:webee_florist/fitur/admin/presentasi/widget/tab_ringkasan_analitik_admin.dart';
import 'package:webee_florist/fitur/pesanan/presentasi/penyedia/penyedia_pesanan.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class HalamanDashboardAdmin extends ConsumerStatefulWidget {
  const HalamanDashboardAdmin({super.key});

  @override
  ConsumerState<HalamanDashboardAdmin> createState() => _HalamanDashboardAdminState();
}

class _HalamanDashboardAdminState extends ConsumerState<HalamanDashboardAdmin> {
  int _indeksTabAktif = 0; // Default Tab Utama: Ringkasan & Analitik
  final GlobalKey<ScaffoldState> _kunciScaffold = GlobalKey<ScaffoldState>();

  String _ambilJudulTab(int indeks) {
    switch (indeks) {
      case 0:
        return 'Ringkasan & Analitik';
      case 1:
        return 'Pesanan Masuk & Logistik Kurir';
      case 2:
        return 'Katalog Produk & Varian Bunga';
      case 3:
        return 'Pelanggan & CRM';
      case 4:
        return 'Laporan & Ekspor';
      case 5:
        return 'Pengaturan Toko Florist';
      default:
        return 'Panel Administrator';
    }
  }

  Widget _buatKontenTab(int indeks) {
    switch (indeks) {
      case 0:
        return TabRingkasanAnalitikAdmin(
          onBukaTabPesanan: () {
            setState(() => _indeksTabAktif = 1);
          },
        );

      case 1:
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(daftarPesananAdminProvider);
            ref.invalidate(ringkasanAdminProvider);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pesanan Masuk, Transaksi & Logistik Kurir',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: WarnaAplikasi.teksUtama,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Kelola konfirmasi bayar, alur perakitan buket, armada mobil/motor, kartu ucapan kaligrafi, dan disposisi WA driver.',
                          style: TextStyle(fontSize: 12, color: WarnaAplikasi.teksSekunder),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const TabPesananTransaksiAdmin(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );

      case 2:
        return const TabKatalogProdukAdmin();

      case 3:
        return _buatPlaceholderTab(
          judul: 'Pelanggan & Riwayat CRM',
          bagian: 'FITUR MENDATANG',
          deskripsi:
              'Basis data pelanggan setia, alamat langganan pengiriman, riwayat pesan ucapan khusus, dan poin keanggotaan VIP Webee Florist.',
          ikon: Icons.people_outline,
        );

      case 4:
        return _buatPlaceholderTab(
          judul: 'Laporan Penjualan & Ekspor Dokumen',
          bagian: 'BAGIAN 3',
          deskripsi:
              'Unduh rekap pembukuan omset bulanan, laporan audit transaksi kasir, analisis tren bunga terlaris, dan ekspor ke format Excel / PDF.',
          ikon: Icons.analytics_outlined,
        );

      case 5:
        return _buatPlaceholderTab(
          judul: 'Pengaturan Toko & Workshop Florist',
          bagian: 'PENGATURAN',
          deskripsi:
              'Pengaturan profil workshop Webee Florist, nomor rekening pembayaran QRIS/BCA, jam buka operasional, dan template otomatis pesan WhatsApp.',
          ikon: Icons.settings_outlined,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buatPlaceholderTab({
    required String judul,
    required String bagian,
    required String deskripsi,
    required IconData ikon,
  }) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: WarnaAplikasi.garisBatas),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: WarnaAplikasi.aksenMerahMuda,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(ikon, size: 40, color: WarnaAplikasi.utama),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: WarnaAplikasi.aksenEmas.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: WarnaAplikasi.aksenEmas.withValues(alpha: 0.4)),
              ),
              child: Text(
                bagian,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: WarnaAplikasi.aksenEmas,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              judul,
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: WarnaAplikasi.teksUtama,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              deskripsi,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: WarnaAplikasi.teksSekunder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          key: _kunciScaffold,
          backgroundColor: WarnaAplikasi.latarBelakang,
          // Drawer untuk tampilan Mobile / Tablet
          drawer: isDesktop
              ? null
              : Drawer(
                  child: BilahSisiAdmin(
                    indeksTerpilih: _indeksTabAktif,
                    onPilihIndeks: (idx) => setState(() => _indeksTabAktif = idx),
                    onTutupDrawer: () => Navigator.of(context).pop(),
                  ),
                ),
          appBar: isDesktop
              ? null
              : AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  scrolledUnderElevation: 1,
                  leading: IconButton(
                    icon: const Icon(Icons.menu, color: WarnaAplikasi.utama),
                    onPressed: () => _kunciScaffold.currentState?.openDrawer(),
                  ),
                  title: Text(
                    _ambilJudulTab(_indeksTabAktif),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: WarnaAplikasi.utama,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh, color: WarnaAplikasi.utama),
                      onPressed: () {
                        ref.invalidate(ringkasanAdminProvider);
                        ref.invalidate(daftarPesananAdminProvider);
                      },
                    ),
                  ],
                ),
          body: Row(
            children: [
              // Sidebar Tetap pada Desktop Layar Lebar
              if (isDesktop)
                BilahSisiAdmin(
                  indeksTerpilih: _indeksTabAktif,
                  onPilihIndeks: (idx) => setState(() => _indeksTabAktif = idx),
                ),

              // Area Konten Utama Tab
              Expanded(
                child: Column(
                  children: [
                    // Top Bar Desktop
                    if (isDesktop)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(bottom: BorderSide(color: WarnaAplikasi.garisBatas)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Portal Admin',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: WarnaAplikasi.teksRedup,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.chevron_right, size: 16, color: WarnaAplikasi.teksRedup),
                                const SizedBox(width: 8),
                                Text(
                                  _ambilJudulTab(_indeksTabAktif),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: WarnaAplikasi.utama,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: WarnaAplikasi.aksenMerahMuda,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.circle, size: 8, color: WarnaAplikasi.sukses),
                                      SizedBox(width: 6),
                                      Text(
                                        'Workshop Florist Buka',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: WarnaAplikasi.utama,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: WarnaAplikasi.latarBelakang,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(color: WarnaAplikasi.garisBatas),
                                    ),
                                  ),
                                  icon: const Icon(Icons.refresh, size: 18, color: WarnaAplikasi.utama),
                                  tooltip: 'Segarkan Seluruh Data',
                                  onPressed: () {
                                    ref.invalidate(ringkasanAdminProvider);
                                    ref.invalidate(daftarPesananAdminProvider);
                                    ref.invalidate(riwayatPesananProvider);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    // Konten Tab Aktif
                    Expanded(
                      child: _buatKontenTab(_indeksTabAktif),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
