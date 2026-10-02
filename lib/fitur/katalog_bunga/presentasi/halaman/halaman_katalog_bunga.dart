import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/fitur/katalog_bunga/data/model/kategori_model.dart';
import 'package:webee_florist/fitur/katalog_bunga/data/model/produk_model.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/halaman/halaman_detail_produk.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/penyedia/penyedia_katalog.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/widget/kartu_produk_bunga.dart';
import 'package:webee_florist/fitur/keranjang/presentasi/penyedia/penyedia_keranjang.dart';
import 'package:webee_florist/fitur/landing_page/presentasi/widget/laci_keranjang_web.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

enum UrutanKatalog {
  populer('Paling Populer'),
  termurah('Harga Terendah'),
  termahal('Harga Tertinggi'),
  namaAz('Nama (A-Z)');

  final String label;
  const UrutanKatalog(this.label);
}

class HalamanKatalogBunga extends ConsumerStatefulWidget {
  const HalamanKatalogBunga({super.key});

  @override
  ConsumerState<HalamanKatalogBunga> createState() => _HalamanKatalogBungaState();
}

class _HalamanKatalogBungaState extends ConsumerState<HalamanKatalogBunga> {
  final TextEditingController _pencarianController = TextEditingController();
  UrutanKatalog _urutanTerpilih = UrutanKatalog.populer;
  bool _hanyaTersedia = false;

  @override
  void initState() {
    super.initState();
    // Sinkronisasi kata kunci dari provider
    _pencarianController.text = ref.read(kataKunciPencarianProvider);
  }

  @override
  void dispose() {
    _pencarianController.dispose();
    super.dispose();
  }

  List<ProdukBungaModel> _filterDanUrutkan(List<ProdukBungaModel> daftarAsli) {
    List<ProdukBungaModel> hasil = List.from(daftarAsli);

    if (_hanyaTersedia) {
      hasil = hasil.where((p) => p.stok > 0 && p.apakahTersedia).toList();
    }

    switch (_urutanTerpilih) {
      case UrutanKatalog.populer:
        // Diurutkan berdasarkan id asli atau stok
        break;
      case UrutanKatalog.termurah:
        hasil.sort((a, b) => a.harga.compareTo(b.harga));
        break;
      case UrutanKatalog.termahal:
        hasil.sort((a, b) => b.harga.compareTo(a.harga));
        break;
      case UrutanKatalog.namaAz:
        hasil.sort((a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()));
        break;
    }

    return hasil;
  }

  @override
  Widget build(BuildContext context) {
    final kategoriAsync = ref.watch(daftarKategoriProvider);
    final produkAsync = ref.watch(daftarProdukProvider);
    final idKategori = ref.watch(idKategoriTerpilihProvider);
    final stateKeranjang = ref.watch(keranjangProvider);
    final lebarLayar = MediaQuery.of(context).size.width;
    final adalahDesktop = lebarLayar >= 960;

    return Scaffold(
      backgroundColor: WarnaAplikasi.latarBelakang,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: WarnaAplikasi.coklatMawar, size: 20),
          tooltip: 'Kembali ke Beranda',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_florist_rounded, color: WarnaAplikasi.aksenMawar, size: 20),
            const SizedBox(width: 8),
            Text(
              'Katalog Rangkaian Bunga',
              style: GoogleFonts.playfairDisplay(
                color: WarnaAplikasi.coklatMawar,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          // Tombol Akses Cepat Keranjang
          IconButton(
            tooltip: 'Keranjang Belanja',
            icon: Badge(
              isLabelVisible: stateKeranjang.totalItem > 0,
              backgroundColor: WarnaAplikasi.aksenMawar,
              label: Text(
                '${stateKeranjang.totalItem}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: WarnaAplikasi.coklatMawar,
              ),
            ),
            onPressed: () => LaciKeranjangWeb.buka(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Hero Header Katalog
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: adalahDesktop ? 48 : 20,
                vertical: adalahDesktop ? 36 : 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(
                  bottom: BorderSide(color: WarnaAplikasi.garisBatas, width: 0.8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      // Breadcrumb
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text(
                              'Beranda',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: WarnaAplikasi.coklatMawar,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_right, size: 14, color: WarnaAplikasi.teksSekunder),
                          const SizedBox(width: 6),
                          Text(
                            'Katalog Bunga Pilihan',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: WarnaAplikasi.teksSekunder,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Judul Utama Katalog
                      Text(
                        'Koleksi Seni Merangkai Bunga',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: adalahDesktop ? 32 : 24,
                          fontWeight: FontWeight.bold,
                          color: WarnaAplikasi.teksUtama,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: Text(
                          'Pilih rangkaian buket mawar impor, bunga meja elegan, standing flower, dan buket kado spesial yang siap dipesan dengan pengiriman hari yang sama.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: adalahDesktop ? 14 : 13,
                            color: WarnaAplikasi.teksSekunder,
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Bar Pencarian & Filter Cepat
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: TextField(
                          controller: _pencarianController,
                          onChanged: (val) {
                            ref.read(kataKunciPencarianProvider.notifier).state = val.trim();
                          },
                          style: GoogleFonts.plusJakartaSans(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Cari nama buket, mawar, lily, meja...',
                            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey.shade400),
                            prefixIcon: const Icon(Icons.search_rounded, color: WarnaAplikasi.coklatMawar),
                            suffixIcon: _pencarianController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 18),
                                    onPressed: () {
                                      _pencarianController.clear();
                                      ref.read(kataKunciPencarianProvider.notifier).state = '';
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: WarnaAplikasi.kremLatar,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.4)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.4)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: WarnaAplikasi.emasKlasik, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Baris Kategori Tabs & Sort Bar
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: adalahDesktop ? 32 : 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kategori Filter Chips
                      kategoriAsync.when(
                        data: (kategoriList) {
                          final semuaDaftar = [
                            const KategoriModel(id: 1, nama: 'Semua Koleksi', slug: 'semua', ikon: null),
                            ...kategoriList.where((k) => k.id != 1),
                          ];

                          return Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: semuaDaftar.map((kat) {
                                final terpilih = idKategori == kat.id;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(
                                      kat.nama,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: terpilih ? FontWeight.bold : FontWeight.w500,
                                        color: terpilih ? Colors.white : WarnaAplikasi.teksUtama,
                                      ),
                                    ),
                                    selected: terpilih,
                                    selectedColor: WarnaAplikasi.coklatMawar,
                                    backgroundColor: Colors.white,
                                    showCheckmark: false,
                                    side: BorderSide(
                                      color: terpilih
                                          ? WarnaAplikasi.coklatMawar
                                          : WarnaAplikasi.garisBatas,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    onSelected: (val) {
                                      if (val) {
                                        ref.read(idKategoriTerpilihProvider.notifier).state = kat.id;
                                      }
                                    },
                                  ),
                                );
                              }).toList(),
                          );
                        },
                        loading: () => const SizedBox(height: 36),
                        error: (_, __) => const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 16),

                      // Baris Ringkasan Hasil & Pengurutan (Sort & Stok Toggle)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Counter Item
                          produkAsync.maybeWhen(
                            data: (list) {
                              final terfilter = _filterDanUrutkan(list);
                              return Text(
                                'Menampilkan ${terfilter.length} rangkaian bunga',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: WarnaAplikasi.teksSekunder,
                                ),
                              );
                            },
                            orElse: () => const Text('Memuat katalog...'),
                          ),

                          // Tombol Opsi Urutan & Filter Stok
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Filter Hanya Tersedia (Desktop & Mobile)
                              InkWell(
                                onTap: () => setState(() => _hanyaTersedia = !_hanyaTersedia),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _hanyaTersedia ? WarnaAplikasi.kremLatar : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _hanyaTersedia ? WarnaAplikasi.emasKlasik : WarnaAplikasi.garisBatas,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _hanyaTersedia ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                                        size: 14,
                                        color: _hanyaTersedia ? WarnaAplikasi.coklatMawar : Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Tersedia Saja',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: WarnaAplikasi.teksUtama,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),

                              // Menu Popup Urutan
                              PopupMenuButton<UrutanKatalog>(
                                initialValue: _urutanTerpilih,
                                tooltip: 'Urutkan Rangkaian',
                                onSelected: (urut) {
                                  setState(() => _urutanTerpilih = urut);
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: WarnaAplikasi.garisBatas),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.sort_rounded, size: 16, color: WarnaAplikasi.coklatMawar),
                                      const SizedBox(width: 6),
                                      Text(
                                        _urutanTerpilih.label,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: WarnaAplikasi.teksUtama,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down, size: 18, color: Colors.grey),
                                    ],
                                  ),
                                ),
                                itemBuilder: (context) => UrutanKatalog.values.map((item) {
                                  return PopupMenuItem<UrutanKatalog>(
                                    value: item,
                                    child: Text(
                                      item.label,
                                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Grid Katalog Produk Responsif
                      produkAsync.when(
                        data: (produkList) {
                          final hasilAkhir = _filterDanUrutkan(produkList);

                          if (hasilAkhir.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: WarnaAplikasi.garisBatas),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.filter_vintage_outlined,
                                    size: 56,
                                    color: WarnaAplikasi.teksRedup,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Tidak Ada Rangkaian Bunga yang Cocok',
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: WarnaAplikasi.teksUtama,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Coba gunakan kata kunci lain atau pilih kategori koleksi yang berbeda.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: WarnaAplikasi.teksSekunder,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  OutlinedButton(
                                    onPressed: () {
                                      _pencarianController.clear();
                                      ref.read(kataKunciPencarianProvider.notifier).state = '';
                                      ref.read(idKategoriTerpilihProvider.notifier).state = 1;
                                      setState(() {
                                        _hanyaTersedia = false;
                                        _urutanTerpilih = UrutanKatalog.populer;
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: WarnaAplikasi.coklatMawar),
                                    ),
                                    child: const Text('Reset Semua Filter'),
                                  ),
                                ],
                              ),
                            );
                          }

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              // Konfigurasi Grid Responsif:
                              // HP < 480: 1 kolom atau 2 kolom (2 kolom dengan rasio 0.65 optimal di HP)
                              // Tablet 480 - 780: 2 kolom (rasio 0.68)
                              // Laptop 780 - 1100: 3 kolom (rasio 0.72)
                              // Desktop >= 1100: 4 kolom (rasio 0.72)
                              final lebar = constraints.maxWidth;
                              final int jumlahKolom = lebar >= 1100
                                  ? 4
                                  : lebar >= 780
                                      ? 3
                                      : lebar >= 520
                                          ? 2
                                          : (lebar < 360 ? 1 : 2);

                              final double childAspectRatio = jumlahKolom == 1
                                  ? 0.95
                                  : (jumlahKolom == 2 ? 0.66 : 0.72);

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: jumlahKolom,
                                  childAspectRatio: childAspectRatio,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: hasilAkhir.length,
                                itemBuilder: (context, index) {
                                  final produk = hasilAkhir[index];
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
                                            content: Text('1x ${produk.nama} ditambahkan ke keranjang.'),
                                            backgroundColor: WarnaAplikasi.coklatMawar,
                                            action: SnackBarAction(
                                              label: 'Buka Keranjang',
                                              textColor: Colors.white,
                                              onPressed: () => LaciKeranjangWeb.buka(context),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.all(64),
                          child: Center(
                            child: CircularProgressIndicator(color: WarnaAplikasi.coklatMawar),
                          ),
                        ),
                        error: (err, _) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'Gagal memuat katalog: $err',
                              style: const TextStyle(color: WarnaAplikasi.bahaya),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
