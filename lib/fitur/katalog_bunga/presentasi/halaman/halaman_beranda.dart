import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/autentikasi/presentasi/penyedia/penyedia_autentikasi.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/halaman/halaman_detail_produk.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/penyedia/penyedia_katalog.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/widget/kartu_produk_bunga.dart';
import 'package:webee_florist/fitur/keranjang/presentasi/penyedia/penyedia_keranjang.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class HalamanBeranda extends ConsumerWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAuth = ref.watch(autentikasiProvider);
    final kategoriAsync = ref.watch(daftarKategoriProvider);
    final produkAsync = ref.watch(daftarProdukProvider);
    final idKategoriTerpilih = ref.watch(idKategoriTerpilihProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(daftarKategoriProvider);
            ref.invalidate(daftarProdukProvider);
          },
          child: CustomScrollView(
            slivers: [
              // Header & Banner Sambutan
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
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
                                'Selamat Datang, ${stateAuth.pengguna?.nama ?? "Tamu Webee"}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: WarnaAplikasi.teksUtama,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                stateAuth.isAdmin ? 'Administrator Toko' : 'Pelanggan Terhormat',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: stateAuth.isAdmin ? WarnaAplikasi.aksenEmas : WarnaAplikasi.utama,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: WarnaAplikasi.utama.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.verified, size: 14, color: WarnaAplikasi.utama),
                                SizedBox(width: 4),
                                Text(
                                  'Bunga Segar Hari Ini',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: WarnaAplikasi.utama,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Banner Promosi Mewah
                      Container(
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
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: WarnaAplikasi.aksenEmas,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'SPESIAL HARI INI',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Kirimkan Kasih Sayang Dengan Rangkaian Eksklusif',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Gratis kartu ucapan personal premium.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.local_florist_rounded,
                              size: 56,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Kolom Pencarian
                      TextField(
                        onChanged: (val) {
                          ref.read(kataKunciPencarianProvider.notifier).state = val;
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari buket mawar, lily, bunga meja...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: ref.watch(kataKunciPencarianProvider).isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    ref.read(kataKunciPencarianProvider.notifier).state = '';
                                  },
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Pilihan Koleksi Bunga',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: WarnaAplikasi.teksUtama,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Baris Kategori Horisontal Chips
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: kategoriAsync.when(
                    data: (kategoriList) => ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: kategoriList.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final kat = kategoriList[index];
                        final terpilih = kat.id == idKategoriTerpilih;

                        return ChoiceChip(
                          label: Text(
                            kat.nama,
                            style: TextStyle(
                              color: terpilih ? Colors.white : WarnaAplikasi.teksUtama,
                              fontWeight: terpilih ? FontWeight.bold : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          selected: terpilih,
                          selectedColor: WarnaAplikasi.utama,
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: terpilih ? WarnaAplikasi.utama : WarnaAplikasi.garisBatas,
                          ),
                          onSelected: (_) {
                            ref.read(idKategoriTerpilihProvider.notifier).state = kat.id;
                          },
                        );
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const SizedBox(),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Grid Daftar Produk
              produkAsync.when(
                data: (produkList) {
                  if (produkList.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey),
                            SizedBox(height: 12),
                            Text(
                              'Tidak ada bunga yang cocok.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final produk = produkList[index];
                          return KartuProdukBunga(
                            produk: produk,
                            padaKetuk: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => HalamanDetailProduk(produk: produk),
                                ),
                              );
                            },
                            padaTambahKeranjang: () async {
                              final sukses = await ref
                                  .read(keranjangProvider.notifier)
                                  .tambahProduk(produk);
                              if (context.mounted && sukses) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('1x ${produk.nama} ditambahkan ke keranjang'),
                                    backgroundColor: WarnaAplikasi.sukses,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          );
                        },
                        childCount: produkList.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, _) => SliverFillRemaining(
                  child: Center(child: Text('Terjadi kesalahan: $err')),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}
