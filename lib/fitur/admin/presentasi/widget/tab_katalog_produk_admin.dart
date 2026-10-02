import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../inti/konstanta/konstanta_api.dart';
import '../../../../inti/konstanta/warna_aplikasi.dart';
import '../../../../inti/utilitas/format_rupiah.dart';
import '../../../katalog_bunga/data/model/kategori_model.dart';
import '../../../katalog_bunga/data/model/produk_model.dart';
import '../../../katalog_bunga/presentasi/penyedia/penyedia_katalog.dart';
import '../penyedia/penyedia_admin.dart';
import 'dialog_input_produk_bunga.dart';

class TabKatalogProdukAdmin extends ConsumerStatefulWidget {
  const TabKatalogProdukAdmin({super.key});

  @override
  ConsumerState<TabKatalogProdukAdmin> createState() => _TabKatalogProdukAdminState();
}

class _TabKatalogProdukAdminState extends ConsumerState<TabKatalogProdukAdmin> {
  final TextEditingController _pencarianController = TextEditingController();

  @override
  void dispose() {
    _pencarianController.dispose();
    super.dispose();
  }

  void _bukaDialogTambahEdit({ProdukBungaModel? produk}) async {
    final hasil = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => DialogInputProdukBunga(produk: produk),
    );
    if (hasil == true && mounted) {
      ref.invalidate(daftarProdukAdminProvider);
      ref.invalidate(daftarProdukProvider);
      ref.invalidate(ringkasanAdminProvider);
    }
  }

  void _konfirmasiHapus(ProdukBungaModel produk) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: WarnaAplikasi.putihHangat,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.5)),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.delete_outline_rounded, color: Colors.red.shade700, size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              'Hapus Rangkaian Bunga',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: WarnaAplikasi.coklatMawar,
              ),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${produk.nama}" dari etalase atelier? Tindakan ini tidak dapat dibatalkan.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: WarnaAplikasi.abuTua,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Batal',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: WarnaAplikasi.abuTua,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final sukses = await ref.read(aksiKatalogAdminProvider.notifier).hapusProduk(produk.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      sukses
                          ? 'Karya "${produk.nama}" berhasil dihapus dari katalog.'
                          : 'Gagal menghapus rangkaian bunga.',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white),
                    ),
                    backgroundColor: sukses ? WarnaAplikasi.coklatMawar : Colors.red.shade800,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Ya, Hapus',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produkAsync = ref.watch(daftarProdukAdminProvider);
    final kategoriAsync = ref.watch(daftarKategoriProvider);
    final kategoriTerpilih = ref.watch(kategoriFilterAdminProvider);
    final adalahMemuatAksi = ref.watch(aksiKatalogAdminProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Seksi Tab
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manajemen Katalog & Koleksi Bunga',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: WarnaAplikasi.coklatMawar,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kelola portofolio buket mawar, bunga meja, variasi musiman, harga atelier, dan sakelar ketersediaan.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: WarnaAplikasi.abuTua,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _bukaDialogTambahEdit(),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(
                  'Tambah Bunga Baru',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: WarnaAplikasi.coklatMawar,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: WarnaAplikasi.emasKlasik, width: 0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Mini Statistik KPI Katalog
          produkAsync.maybeWhen(
            data: (semua) => _bangunStatistikMini(semua),
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),

          // Bilah Pencarian & Kategori Filter
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: WarnaAplikasi.coklatMawar.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pencarianController,
                        onChanged: (val) {
                          ref.read(pencarianKatalogAdminProvider.notifier).state = val;
                        },
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Cari karya rangkaian bunga berdasarkan nama atau filosofi...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: WarnaAplikasi.abuTua.withValues(alpha: 0.6),
                          ),
                          prefixIcon: const Icon(Icons.search_rounded, color: WarnaAplikasi.emasKlasik, size: 20),
                          suffixIcon: _pencarianController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () {
                                    _pencarianController.clear();
                                    ref.read(pencarianKatalogAdminProvider.notifier).state = '';
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: WarnaAplikasi.kremLatar.withValues(alpha: 0.5),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Deretan Chip Kategori
                kategoriAsync.when(
                  data: (kategoriList) {
                    final semuaOpsi = [
                      const KategoriModel(id: 0, nama: 'Semua Koleksi', slug: 'semua'),
                      ...kategoriList.where((k) => k.slug != 'semua' && k.id > 0),
                    ];
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: semuaOpsi.map((k) {
                          final terpilih = k.id == kategoriTerpilih;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(k.nama),
                              selected: terpilih,
                              onSelected: (_) {
                                ref.read(kategoriFilterAdminProvider.notifier).state = k.id;
                              },
                              labelStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: terpilih ? FontWeight.bold : FontWeight.w500,
                                color: terpilih ? Colors.white : WarnaAplikasi.coklatMawar,
                              ),
                              backgroundColor: Colors.white,
                              selectedColor: WarnaAplikasi.coklatMawar,
                              checkmarkColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: terpilih
                                      ? WarnaAplikasi.coklatMawar
                                      : WarnaAplikasi.emasKlasik.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                  loading: () => const SizedBox(height: 32),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Konten Tabel / Kartu Produk
          if (adalahMemuatAksi)
            const LinearProgressIndicator(
              color: WarnaAplikasi.emasKlasik,
              backgroundColor: WarnaAplikasi.kremLatar,
            ),

          produkAsync.when(
            data: (daftarProduk) {
              if (daftarProduk.isEmpty) {
                return _bangunStatusKosong();
              }
              final kategoriList = kategoriAsync.value ?? [];
              return LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 900) {
                    return _bangunTampilanKartuMobile(daftarProduk, kategoriList);
                  }
                  return _bangunTabelDesktop(daftarProduk, kategoriList);
                },
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: CircularProgressIndicator(color: WarnaAplikasi.coklatMawar),
              ),
            ),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: Text(
                  'Terjadi kendala saat memuat katalog: $err',
                  style: GoogleFonts.plusJakartaSans(color: Colors.red.shade700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bangunStatistikMini(List<ProdukBungaModel> list) {
    final totalVarian = list.length;
    final stokMenipis = list.where((p) => p.stok < 5).length;
    final totalUnggulan = list.where((p) => p.apakahUnggulan).length;
    final totalTersedia = list.where((p) => p.apakahTersedia).length;

    return Row(
      children: [
        Expanded(
          child: _bangunKartuMiniStat(
            judul: 'Total Varian',
            nilai: '$totalVarian',
            satuan: 'Rangkaian',
            ikon: Icons.local_florist_rounded,
            warnaIkon: WarnaAplikasi.coklatMawar,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _bangunKartuMiniStat(
            judul: 'Stok Menipis (<5)',
            nilai: '$stokMenipis',
            satuan: 'Perlu Restok',
            ikon: Icons.warning_amber_rounded,
            warnaIkon: stokMenipis > 0 ? Colors.amber.shade800 : WarnaAplikasi.abuTua,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _bangunKartuMiniStat(
            judul: 'Koleksi Unggulan',
            nilai: '$totalUnggulan',
            satuan: 'Di Etalase Depan',
            ikon: Icons.star_rounded,
            warnaIkon: WarnaAplikasi.emasKlasik,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _bangunKartuMiniStat(
            judul: 'Kondisi Tersedia',
            nilai: '$totalTersedia',
            satuan: 'Siap Dipesan',
            ikon: Icons.check_circle_outline_rounded,
            warnaIkon: WarnaAplikasi.hijauStatus,
          ),
        ),
      ],
    );
  }

  Widget _bangunKartuMiniStat({
    required String judul,
    required String nilai,
    required String satuan,
    required IconData ikon,
    required Color warnaIkon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: WarnaAplikasi.coklatMawar.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: warnaIkon.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(ikon, color: warnaIkon, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  judul,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: WarnaAplikasi.abuTua,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      nilai,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: WarnaAplikasi.coklatMawar,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        satuan,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: WarnaAplikasi.abuTua,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bangunTabelDesktop(List<ProdukBungaModel> list, List<KategoriModel> kategoriList) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: WarnaAplikasi.coklatMawar.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            // Header Baris Tabel
            Container(
              color: WarnaAplikasi.kremLatar,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const SizedBox(width: 60, child: Text('#', style: _gayaHeaderTabel)),
                  const Expanded(flex: 3, child: Text('Karya Rangkaian & Kategori', style: _gayaHeaderTabel)),
                  const Expanded(flex: 2, child: Text('Harga Atelier', style: _gayaHeaderTabel)),
                  const Expanded(flex: 2, child: Text('Stok Kuntum', style: _gayaHeaderTabel)),
                  const Expanded(flex: 2, child: Text('Ketersediaan', style: _gayaHeaderTabel)),
                  const SizedBox(width: 110, child: Center(child: Text('Tindakan', style: _gayaHeaderTabel))),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE8DFC8)),

            // Baris-baris produk
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.6, color: Color(0xFFF0EAE1)),
              itemBuilder: (context, idx) {
                final item = list[idx];
                final namaKategori = _cariNamaKategori(item.kategoriId, kategoriList);

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      // Thumbnail Gambar
                      SizedBox(
                        width: 60,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.3)),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: (item.urlGambar ?? '').isNotEmpty
                              ? Image.network(
                                  KonstantaApi.formatUrlGambar(item.urlGambar),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.local_florist_rounded,
                                    size: 20,
                                    color: WarnaAplikasi.coklatMawar,
                                  ),
                                )
                              : const Icon(
                                  Icons.local_florist_rounded,
                                  size: 20,
                                  color: WarnaAplikasi.coklatMawar,
                                ),
                        ),
                      ),

                      // Nama Bunga, Kategori, & Badge Unggulan
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    item.nama,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: WarnaAplikasi.hitamMewah,
                                    ),
                                  ),
                                ),
                                if (item.apakahUnggulan) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.5),
                                        width: 0.6,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star_rounded, size: 12, color: WarnaAplikasi.emasKlasik),
                                        const SizedBox(width: 3),
                                        Text(
                                          'Unggulan',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: WarnaAplikasi.coklatMawar,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              namaKategori,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: WarnaAplikasi.abuTua,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Harga
                      Expanded(
                        flex: 2,
                        child: Text(
                          FormatRupiah.format(item.harga),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: WarnaAplikasi.coklatMawar,
                          ),
                        ),
                      ),

                      // Stok Unit & Quick Stepper Adjuster
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: WarnaAplikasi.kremLatar,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: item.stok > 0
                                        ? () {
                                            ref
                                                .read(aksiKatalogAdminProvider.notifier)
                                                .sesuaikanStok(item.id, perubahan: -1);
                                          }
                                        : null,
                                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: Icon(
                                        Icons.remove_rounded,
                                        size: 16,
                                        color: item.stok > 0 ? WarnaAplikasi.coklatMawar : Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    child: Text(
                                      '${item.stok}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: WarnaAplikasi.hitamMewah,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      ref
                                          .read(aksiKatalogAdminProvider.notifier)
                                          .sesuaikanStok(item.id, perubahan: 1);
                                    },
                                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: Icon(
                                        Icons.add_rounded,
                                        size: 16,
                                        color: WarnaAplikasi.coklatMawar,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (item.stok < 5) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.amber.shade600, width: 0.6),
                                ),
                                child: Text(
                                  'Menipis',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.amber.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Status Ketersediaan (Sakelar)
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Switch.adaptive(
                              value: item.apakahTersedia,
                              activeColor: WarnaAplikasi.hijauStatus,
                              onChanged: (val) {
                                ref
                                    .read(aksiKatalogAdminProvider.notifier)
                                    .ubahStatusTersedia(item.id, val);
                              },
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.apakahTersedia ? 'Tersedia' : 'Habis',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: item.apakahTersedia ? WarnaAplikasi.hijauStatus : Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tindakan (Edit & Hapus)
                      SizedBox(
                        width: 110,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              color: WarnaAplikasi.coklatMawar,
                              tooltip: 'Edit Bunga',
                              onPressed: () => _bukaDialogTambahEdit(produk: item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 20),
                              color: Colors.red.shade700,
                              tooltip: 'Hapus Rangkaian',
                              onPressed: () => _konfirmasiHapus(item),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _bangunTampilanKartuMobile(List<ProdukBungaModel> list, List<KategoriModel> kategoriList) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, idx) {
        final item = list[idx];
        final namaKategori = _cariNamaKategori(item.kategoriId, kategoriList);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.3)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: (item.urlGambar ?? '').isNotEmpty
                        ? Image.network(
                            KonstantaApi.formatUrlGambar(item.urlGambar),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.local_florist_rounded,
                              color: WarnaAplikasi.coklatMawar,
                            ),
                          )
                        : const Icon(Icons.local_florist_rounded, color: WarnaAplikasi.coklatMawar),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.nama,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: WarnaAplikasi.hitamMewah,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          namaKategori,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: WarnaAplikasi.abuTua,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          FormatRupiah.format(item.harga),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: WarnaAplikasi.coklatMawar,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.2)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Stok: ',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: WarnaAplikasi.abuTua),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: WarnaAplikasi.kremLatar,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: item.stok > 0
                                  ? () => ref
                                      .read(aksiKatalogAdminProvider.notifier)
                                      .sesuaikanStok(item.id, perubahan: -1)
                                  : null,
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.remove, size: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '${item.stok}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => ref
                                  .read(aksiKatalogAdminProvider.notifier)
                                  .sesuaikanStok(item.id, perubahan: 1),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.add, size: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        color: WarnaAplikasi.coklatMawar,
                        onPressed: () => _bukaDialogTambahEdit(produk: item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 20),
                        color: Colors.red.shade700,
                        onPressed: () => _konfirmasiHapus(item),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bangunStatusKosong() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Icon(Icons.filter_vintage_outlined, size: 48, color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.6)),
          const SizedBox(height: 16),
          Text(
            'Tidak Ada Rangkaian Bunga',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: WarnaAplikasi.coklatMawar,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tidak ditemukan rangkaian bunga yang cocok dengan kata kunci pencarian atau kategori ini.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: WarnaAplikasi.abuTua,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _bukaDialogTambahEdit(),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Tambah Bunga Baru Sekarang'),
            style: ElevatedButton.styleFrom(
              backgroundColor: WarnaAplikasi.coklatMawar,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  String _cariNamaKategori(int id, List<KategoriModel> daftar) {
    try {
      return daftar.firstWhere((k) => k.id == id).nama;
    } catch (_) {
      switch (id) {
        case 1:
          return 'Buket Mawar Romantis';
        case 2:
          return 'Bunga Meja & Vas';
        case 3:
          return 'Buket Wisuda & Kelulusan';
        case 4:
          return 'Bunga Papan Ucapan';
        case 5:
          return 'Buket Wisuda';
        case 6:
          return 'Bunga Papan Ucapan';
        default:
          return 'Rangkaian Khusus';
      }
    }
  }
}

const TextStyle _gayaHeaderTabel = TextStyle(
  fontFamily: 'Plus Jakarta Sans',
  fontSize: 12,
  fontWeight: FontWeight.w700,
  color: WarnaAplikasi.coklatMawar,
  letterSpacing: 0.2,
);
