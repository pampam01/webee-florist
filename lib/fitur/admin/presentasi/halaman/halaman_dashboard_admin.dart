import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/admin/data/model/ringkasan_admin_model.dart';
import 'package:webee_florist/fitur/admin/presentasi/penyedia/penyedia_admin.dart';
import 'package:webee_florist/fitur/pesanan/presentasi/penyedia/penyedia_pesanan.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';
import 'package:webee_florist/inti/utilitas/format_rupiah.dart';

class HalamanDashboardAdmin extends ConsumerWidget {
  const HalamanDashboardAdmin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ringkasanAsync = ref.watch(ringkasanAdminProvider);
    final riwayatPesananAsync = ref.watch(riwayatPesananProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Administrator Florist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(ringkasanAdminProvider);
              ref.invalidate(riwayatPesananProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(ringkasanAdminProvider);
          ref.invalidate(riwayatPesananProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Omset Utama
              ringkasanAsync.when(
                data: (RingkasanAdminModel ringkasan) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: WarnaAplikasi.gradienUtama,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: WarnaAplikasi.utama.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.monetization_on_outlined, color: WarnaAplikasi.aksenEmas, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'TOTAL OMSET TOKO BUNGA',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        FormatRupiah.format(ringkasan.totalOmset),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Dari ${ringkasan.totalPesanan} transaksi bunga berhasil',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox(),
              ),

              const SizedBox(height: 20),

              // Kartu-kartu Metrik 2 Kolom
              ringkasanAsync.when(
                data: (RingkasanAdminModel ringkasan) => GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    _buatKartuMetrik(
                      judul: 'Pesanan Dirangkai',
                      nilai: '${ringkasan.pesananDiproses}',
                      ikon: Icons.brush_outlined,
                      warna: WarnaAplikasi.info,
                    ),
                    _buatKartuMetrik(
                      judul: 'Menunggu Bayar',
                      nilai: '${ringkasan.pesananMenungguBayar}',
                      ikon: Icons.hourglass_top,
                      warna: WarnaAplikasi.peringatan,
                    ),
                    _buatKartuMetrik(
                      judul: 'Total Pelanggan',
                      nilai: '${ringkasan.totalPelanggan}',
                      ikon: Icons.people_outline,
                      warna: WarnaAplikasi.utama,
                    ),
                    _buatKartuMetrik(
                      judul: 'Varian Bunga Aktif',
                      nilai: '${ringkasan.totalProdukAktif}',
                      ikon: Icons.local_florist_outlined,
                      warna: WarnaAplikasi.aksenMawar,
                    ),
                  ],
                ),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),

              const SizedBox(height: 28),

              // Manajemen Pesanan Terkini
              const Text(
                'Manajemen Status Pesanan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: WarnaAplikasi.utama,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ubah status alur kerja buket bunga dari perakitan hingga sampai di tangan pelanggan.',
                style: TextStyle(fontSize: 12, color: WarnaAplikasi.teksSekunder),
              ),
              const SizedBox(height: 14),

              riwayatPesananAsync.when(
                data: (daftar) {
                  if (daftar.isEmpty) {
                    return const Text('Belum ada pesanan masuk.');
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: daftar.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final p = daftar[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: WarnaAplikasi.garisBatas),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  p.nomorPesanan,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: WarnaAplikasi.utama,
                                  ),
                                ),
                                Text(
                                  FormatRupiah.format(p.grandTotal),
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Penerima: ${p.namaPenerima} | Status saat ini: ${p.status}',
                              style: const TextStyle(fontSize: 12, color: WarnaAplikasi.teksSekunder),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              children: [
                                if (p.status != 'diproses')
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(buatPesananProvider.notifier)
                                          .perbaruiStatusPesanan(p.id, 'diproses');
                                    },
                                    child: const Text('Rangkai Bunga', style: TextStyle(fontSize: 11)),
                                  ),
                                if (p.status != 'dikirim')
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(buatPesananProvider.notifier)
                                          .perbaruiStatusPesanan(p.id, 'dikirim');
                                    },
                                    child: const Text('Kirim Kurir', style: TextStyle(fontSize: 11)),
                                  ),
                                if (p.status != 'selesai')
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(buatPesananProvider.notifier)
                                          .perbaruiStatusPesanan(p.id, 'selesai');
                                    },
                                    child: const Text('Tandai Selesai', style: TextStyle(fontSize: 11)),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error: $err'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buatKartuMetrik({
    required String judul,
    required String nilai,
    required IconData ikon,
    required Color warna,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
            children: [
              Icon(ikon, color: warna, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  judul,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: WarnaAplikasi.teksSekunder),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            nilai,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: warna,
            ),
          ),
        ],
      ),
    );
  }
}
