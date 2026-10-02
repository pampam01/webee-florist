import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/fitur/admin/data/model/ringkasan_admin_model.dart';
import 'package:webee_florist/fitur/admin/presentasi/penyedia/penyedia_admin.dart';
import 'package:webee_florist/fitur/admin/presentasi/widget/badge_urgensi_pengantaran.dart';
import 'package:webee_florist/fitur/admin/presentasi/widget/grafik_batang_omset_mingguan.dart';
import 'package:webee_florist/fitur/admin/presentasi/widget/grafik_donat_kategori_bunga.dart';
import 'package:webee_florist/fitur/pesanan/presentasi/penyedia/penyedia_pesanan.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';
import 'package:webee_florist/inti/utilitas/format_rupiah.dart';

class TabRingkasanAnalitikAdmin extends ConsumerWidget {
  final VoidCallback onBukaTabPesanan;

  const TabRingkasanAnalitikAdmin({
    super.key,
    required this.onBukaTabPesanan,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ringkasanAsync = ref.watch(ringkasanAdminProvider);
    final pesananAsync = ref.watch(daftarPesananAdminProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Salam & Aksi Cepat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Kinerja & Analitik Toko Bunga',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: WarnaAplikasi.teksUtama,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pantau perputaran omset, performa armada kurir, serta varian bunga terlaris secara langsung.',
                      style: TextStyle(fontSize: 12, color: WarnaAplikasi.teksSekunder),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: WarnaAplikasi.utama,
                  side: const BorderSide(color: WarnaAplikasi.garisBatas),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ref.invalidate(ringkasanAdminProvider);
                  ref.invalidate(daftarPesananAdminProvider);
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Segarkan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Banner Omset Utama dengan Desain Mewah
          ringkasanAsync.when(
            data: (RingkasanAdminModel r) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: WarnaAplikasi.gradienUtama,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: WarnaAplikasi.utama.withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.trending_up, color: WarnaAplikasi.aksenEmas, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    '+18.4% BULAN INI',
                                    style: TextStyle(
                                      color: WarnaAplikasi.aksenEmas,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'TOTAL OMSET PENJUALAN',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          FormatRupiah.format(r.totalOmset),
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tercatat dari ${r.totalPesanan} transaksi rangkaian bunga tuntas dikirimkan.',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: const Icon(
                      Icons.auto_graph_outlined,
                      color: WarnaAplikasi.aksenEmas,
                      size: 42,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 18),

          // 4 Kartu KPI Bar
          ringkasanAsync.when(
            data: (RingkasanAdminModel r) => LayoutBuilder(
              builder: (context, constraints) {
                final lebar = constraints.maxWidth;
                final jumlahKolom = lebar > 800 ? 4 : (lebar > 500 ? 2 : 1);
                return GridView.count(
                  crossAxisCount: jumlahKolom,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: jumlahKolom == 4 ? 1.6 : (jumlahKolom == 2 ? 1.45 : 2.5),
                  children: [
                    _buatKartuKpi(
                      judul: 'Sedang Dirangkai',
                      nilai: '${r.pesananDiproses}',
                      subteks: 'Buket di meja perangkai',
                      ikon: Icons.brush_outlined,
                      warna: WarnaAplikasi.info,
                    ),
                    _buatKartuKpi(
                      judul: 'Menunggu Bayar',
                      nilai: '${r.pesananMenungguBayar}',
                      subteks: 'Invoice belum lunas',
                      ikon: Icons.hourglass_top_outlined,
                      warna: WarnaAplikasi.peringatan,
                    ),
                    _buatKartuKpi(
                      judul: 'Pelanggan VIP',
                      nilai: '${r.totalPelanggan}',
                      subteks: 'Pelanggan terdaftar',
                      ikon: Icons.people_outline,
                      warna: WarnaAplikasi.utama,
                    ),
                    _buatKartuKpi(
                      judul: 'Koleksi Bunga Aktif',
                      nilai: '${r.totalProdukAktif}',
                      subteks: 'Varian katalog siap pesan',
                      ikon: Icons.local_florist_outlined,
                      warna: WarnaAplikasi.aksenMawar,
                    ),
                  ],
                );
              },
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 24),

          // Area Dua Visual Chart (Grafik Batang 7 Hari + Grafik Donut Kategori)
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 950) {
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: GrafikBatangOmsetMingguan()),
                    SizedBox(width: 18),
                    Expanded(flex: 5, child: GrafikDonatKategoriBunga()),
                  ],
                );
              }
              return const Column(
                children: [
                  GrafikBatangOmsetMingguan(),
                  SizedBox(height: 18),
                  GrafikDonatKategoriBunga(),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Metrik Logistik & Efisiensi Florist
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: WarnaAplikasi.garisBatas),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: WarnaAplikasi.aksenMerahMuda,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.local_shipping_outlined,
                              size: 18,
                              color: WarnaAplikasi.utama,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Kinerja Logistik & Armada Pengantaran',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: WarnaAplikasi.teksUtama,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: onBukaTabPesanan,
                      icon: const Icon(Icons.arrow_forward, size: 14),
                      label: const Text('Kelola Logistik di Tab Pesanan', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    return Row(
                      children: [
                        Expanded(
                          child: _buatItemLogistik(
                            ikon: Icons.ac_unit,
                            judul: 'Mobil Berpendingin',
                            deskripsi: 'Vas Kristal & Standing Flower',
                            antaran: '8 Pengantaran',
                            warna: WarnaAplikasi.utama,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buatItemLogistik(
                            ikon: Icons.two_wheeler,
                            judul: 'Motor Khusus Florist',
                            deskripsi: 'Buket Anti-Angin Segar',
                            antaran: '18 Pengantaran',
                            warna: WarnaAplikasi.aksenMawar,
                          ),
                        ),
                        if (isWide) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buatItemLogistik(
                              ikon: Icons.delivery_dining,
                              judul: 'Kurir Eksternal Instan',
                              deskripsi: 'GrabExpress / GoSend',
                              antaran: '4 Pengantaran',
                              warna: WarnaAplikasi.aksenEmas,
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Feed Aktivitas Pesanan Terbaru
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: WarnaAplikasi.garisBatas),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: WarnaAplikasi.aksenMerahMuda,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.receipt_long_outlined,
                              size: 18,
                              color: WarnaAplikasi.utama,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Transaksi Masuk Terkini',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: WarnaAplikasi.teksUtama,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WarnaAplikasi.utama,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: onBukaTabPesanan,
                      child: const Text('Buka Tab Pesanan Lengkap', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                pesananAsync.when(
                  data: (daftar) {
                    if (daftar.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: Text('Belum ada transaksi tercatat.')),
                      );
                    }
                    final cuplikan = daftar.take(4).toList();
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cuplikan.length,
                      separatorBuilder: (_, __) => const Divider(height: 16, color: WarnaAplikasi.garisBatas),
                      itemBuilder: (context, index) {
                        final p = cuplikan[index];
                        return Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: WarnaAplikasi.latarBelakang,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: WarnaAplikasi.garisBatas),
                              ),
                              child: const Icon(Icons.local_florist, size: 18, color: WarnaAplikasi.utama),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '#${p.nomorPesanan}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: WarnaAplikasi.utama),
                                      ),
                                      const SizedBox(width: 8),
                                      BadgeUrgensiPengantaran(tanggalKirim: p.tanggalKirim),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Penerima: ${p.namaPenerima} • ${p.alamatPengiriman}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11, color: WarnaAplikasi.teksSekunder),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  FormatRupiah.format(p.grandTotal),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  p.status,
                                  style: const TextStyle(fontSize: 10, color: WarnaAplikasi.teksSekunder),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buatKartuKpi({
    required String judul,
    required String nilai,
    required String subteks,
    required IconData ikon,
    required Color warna,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WarnaAplikasi.garisBatas),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  judul,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: WarnaAplikasi.teksSekunder, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: warna.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(ikon, color: warna, size: 15),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              nilai,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: warna,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subteks,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: WarnaAplikasi.teksRedup),
          ),
        ],
      ),
    );
  }

  Widget _buatItemLogistik({
    required IconData ikon,
    required String judul,
    required String deskripsi,
    required String antaran,
    required Color warna,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WarnaAplikasi.latarBelakang,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WarnaAplikasi.garisBatas),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ikon, size: 18, color: warna),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  judul,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: WarnaAplikasi.teksUtama),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(deskripsi, style: const TextStyle(fontSize: 10, color: WarnaAplikasi.teksSekunder)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: warna.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              antaran,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: warna),
            ),
          ),
        ],
      ),
    );
  }
}
