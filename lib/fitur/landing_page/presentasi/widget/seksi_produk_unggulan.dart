import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/fitur/katalog_bunga/data/model/produk_model.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/halaman/halaman_detail_produk.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/penyedia/penyedia_katalog.dart';
import 'package:webee_florist/fitur/keranjang/presentasi/penyedia/penyedia_keranjang.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';
import 'package:webee_florist/inti/utilitas/format_rupiah.dart';
import 'laci_keranjang_web.dart';

class SeksiProdukUnggulan extends ConsumerWidget {
  const SeksiProdukUnggulan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final produkAsync = ref.watch(daftarProdukProvider);
    final idKategori = ref.watch(idKategoriTerpilihProvider);
    final lebarLayar = MediaQuery.of(context).size.width;
    final adalahDesktop = lebarLayar >= 960;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: adalahDesktop ? 64 : 24,
        vertical: 54,
      ),
      color: WarnaAplikasi.latarBelakang,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Header Seksi (SEO H2)
              Text(
                'Koleksi Rangkaian Terpopuler',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: adalahDesktop ? 32 : 26,
                  fontWeight: FontWeight.w800,
                  color: WarnaAplikasi.teksUtama,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text(
                  'Buket bunga segar pilihan yang paling diminati untuk menyemarakkan momentum kasih sayang, ucapan selamat, dan dekorasi ruang.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: WarnaAplikasi.teksSekunder,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Filter Kategori Tab
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tabFilter(context, ref, id: 1, label: 'Semua Koleksi', aktif: idKategori == 1),
                    const SizedBox(width: 8),
                    _tabFilter(context, ref, id: 2, label: 'Buket Mawar', aktif: idKategori == 2),
                    const SizedBox(width: 8),
                    _tabFilter(context, ref, id: 3, label: 'Bunga Meja & Vas', aktif: idKategori == 3),
                    const SizedBox(width: 8),
                    _tabFilter(context, ref, id: 4, label: 'Buket Wisuda', aktif: idKategori == 4),
                    const SizedBox(width: 8),
                    _tabFilter(context, ref, id: 5, label: 'Bunga Papan', aktif: idKategori == 5),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Tampilan Grid Produk
              produkAsync.when(
                data: (produkList) {
                  if (produkList.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: WarnaAplikasi.garisBatas),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.spa_outlined, size: 48, color: WarnaAplikasi.teksRedup),
                          SizedBox(height: 12),
                          Text(
                            'Belum ada rangkaian bunga untuk kategori ini.',
                            style: TextStyle(color: WarnaAplikasi.teksSekunder),
                          ),
                        ],
                      ),
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final kolom = constraints.maxWidth >= 1000
                          ? 4
                          : constraints.maxWidth >= 640
                              ? 2
                              : 1;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: kolom,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                        ),
                        itemCount: produkList.length,
                        itemBuilder: (context, index) {
                          final produk = produkList[index];
                          return _kartuBunga(context, ref, produk);
                        },
                      );
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator(color: WarnaAplikasi.utama)),
                ),
                error: (err, _) => Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('Gagal memuat produk: $err'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabFilter(
    BuildContext context,
    WidgetRef ref, {
    required int id,
    required String label,
    required bool aktif,
  }) {
    return InkWell(
      onTap: () {
        ref.read(idKategoriTerpilihProvider.notifier).state = id;
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: aktif ? WarnaAplikasi.utama : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: aktif ? WarnaAplikasi.utama : WarnaAplikasi.garisBatas,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: aktif ? FontWeight.bold : FontWeight.w500,
            color: aktif ? Colors.white : WarnaAplikasi.teksUtama,
          ),
        ),
      ),
    );
  }

  Widget _kartuBunga(BuildContext context, WidgetRef ref, ProdukBungaModel produk) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WarnaAplikasi.garisBatas),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => HalamanDetailProduk(produk: produk),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Foto Bunga
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: produk.urlGambar != null && produk.urlGambar!.isNotEmpty
                        ? Image.network(
                            produk.urlGambar!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: WarnaAplikasi.latarBelakang,
                              child: const Icon(Icons.local_florist, size: 48, color: WarnaAplikasi.utama),
                            ),
                          )
                        : Container(
                            color: WarnaAplikasi.latarBelakang,
                            child: const Icon(Icons.local_florist, size: 48, color: WarnaAplikasi.utama),
                          ),
                  ),
                  // Lencana Stok
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: WarnaAplikasi.garisBatas),
                      ),
                      child: Text(
                        produk.stok > 0 ? 'Sisa ${produk.stok}' : 'Habis',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: produk.stok > 0 ? WarnaAplikasi.sukses : WarnaAplikasi.bahaya,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Detail Nama & Harga
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: WarnaAplikasi.teksUtama,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    FormatRupiah.format(produk.harga),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: WarnaAplikasi.utama,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tombol Cepat Tambah ke Keranjang
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton.icon(
                      onPressed: produk.stok > 0
                          ? () async {
                              final sukses = await ref
                                  .read(keranjangProvider.notifier)
                                  .tambahProduk(produk);
                              if (context.mounted && sukses) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('1x ${produk.nama} ditambahkan ke keranjang.'),
                                    backgroundColor: WarnaAplikasi.sukses,
                                    action: SnackBarAction(
                                      label: 'Lihat Keranjang',
                                      textColor: Colors.white,
                                      onPressed: () => LaciKeranjangWeb.buka(context),
                                    ),
                                  ),
                                );
                              }
                            }
                          : null,
                      icon: const Icon(Icons.add_shopping_cart, size: 14),
                      label: const Text('Tambah', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: WarnaAplikasi.utama,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
