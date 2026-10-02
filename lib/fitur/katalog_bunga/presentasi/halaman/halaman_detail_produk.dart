import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/fitur/katalog_bunga/data/model/produk_model.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/widget/slider_foto_bunga.dart';
import 'package:webee_florist/fitur/keranjang/presentasi/penyedia/penyedia_keranjang.dart';
import 'package:webee_florist/fitur/landing_page/presentasi/widget/laci_keranjang_web.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';
import 'package:webee_florist/inti/utilitas/format_rupiah.dart';

class HalamanDetailProduk extends ConsumerStatefulWidget {
  final ProdukBungaModel produk;

  const HalamanDetailProduk({super.key, required this.produk});

  @override
  ConsumerState<HalamanDetailProduk> createState() => _HalamanDetailProdukState();
}

class _HalamanDetailProdukState extends ConsumerState<HalamanDetailProduk> {
  int _kuantitas = 1;
  final _catatanKontroller = TextEditingController();

  @override
  void dispose() {
    _catatanKontroller.dispose();
    super.dispose();
  }

  void _tambahKuantitas() {
    if (_kuantitas < widget.produk.stok) {
      setState(() => _kuantitas++);
    }
  }

  void _kurangKuantitas() {
    if (_kuantitas > 1) {
      setState(() => _kuantitas--);
    }
  }

  Future<void> _masukkanKeranjang({bool bukaLaciLangsung = false}) async {
    final sukses = await ref.read(keranjangProvider.notifier).tambahProduk(
          widget.produk,
          kuantitas: _kuantitas,
          catatan: _catatanKontroller.text.trim().isNotEmpty
              ? _catatanKontroller.text.trim()
              : null,
        );

    if (!mounted) return;

    if (sukses) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$_kuantitas x ${widget.produk.nama} berhasil ditambahkan ke keranjang.',
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: WarnaAplikasi.coklatMawar,
          action: SnackBarAction(
            label: 'Lihat Keranjang',
            textColor: Colors.white,
            onPressed: () => LaciKeranjangWeb.buka(context),
          ),
        ),
      );

      if (bukaLaciLangsung) {
        LaciKeranjangWeb.buka(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateKeranjang = ref.watch(keranjangProvider);

    return Scaffold(
      backgroundColor: WarnaAplikasi.latarBelakang,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Détail Bouquet',
          style: GoogleFonts.playfairDisplay(
            color: WarnaAplikasi.coklatMawar,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        actions: [
          // Keranjang Belanja dengan Badge
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final adalahDesktop = constraints.maxWidth >= 900;
          if (adalahDesktop) {
            return _tampilanDesktop(context);
          } else {
            return _tampilanMobile(context);
          }
        },
      ),
    );
  }

  // =========================================================================
  // TAMPILAN MOBILE (RESPONSIF PHONE DENGAN STICKY BOTTOM BAR)
  // =========================================================================
  Widget _tampilanMobile(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wadah Slider Foto dengan AspectRatio 1:1 (Auto Zoom-Out & Fit Layar HP)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SliderFotoBunga(
                    daftarFoto: widget.produk.semuaFoto,
                    aspectRatio: 1.0, // Proporsi 1:1 sempurna di layar HP
                    tampilkanThumbnailBawah: true,
                    bisaDiKlikZoom: true,
                    judulProduk: widget.produk.nama,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                const SizedBox(height: 12),

                // Area Detail Informasi & Form Catatan
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge Koleksi & Stok (Wrap agar tidak pernah overflow)
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: WarnaAplikasi.kremLatar,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.local_florist,
                                  size: 13,
                                  color: WarnaAplikasi.coklatMawar,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Sélection Florale',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: WarnaAplikasi.coklatMawar,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.produk.stok > 0
                                  ? WarnaAplikasi.sukses.withValues(alpha: 0.1)
                                  : WarnaAplikasi.bahaya.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.produk.stok > 0
                                  ? 'Tersedia: ${widget.produk.stok} buket'
                                  : 'Stok Habis',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: widget.produk.stok > 0
                                    ? WarnaAplikasi.sukses
                                    : WarnaAplikasi.bahaya,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Nama Bunga
                      Text(
                        widget.produk.nama,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: WarnaAplikasi.teksUtama,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Harga Produk
                      Text(
                        FormatRupiah.format(widget.produk.harga),
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: WarnaAplikasi.aksenMawar,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Keunggulan Atelier Florist
                      _barisJaminanKualitas(),

                      const SizedBox(height: 16),
                      const Divider(color: WarnaAplikasi.garisBatas),
                      const SizedBox(height: 12),

                      // Deskripsi Rangkaian
                      Text(
                        'Deskripsi Rangkaian',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: WarnaAplikasi.teksUtama,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.produk.deskripsi,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: WarnaAplikasi.teksSekunder,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Form Catatan / Ucapan Kaligrafi
                      Text(
                        'Kartu Ucapan & Permintaan Khusus',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: WarnaAplikasi.teksUtama,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _catatanKontroller,
                        maxLines: 3,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Tuliskan ucapan menyentuh untuk penerima buket atau preferensi warna pita...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 36),
                            child: Icon(Icons.edit_note_rounded, color: WarnaAplikasi.coklatMawar),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: WarnaAplikasi.garisBatas),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: WarnaAplikasi.emasKlasik, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // STICKY BOTTOM ACTION BAR (RESPONSIF TANPA OVERFLOW DI HP APAPUN)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
            border: const Border(
              top: BorderSide(color: WarnaAplikasi.garisBatas, width: 0.8),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                // Total Harga
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total Pesanan',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: WarnaAplikasi.teksSekunder,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          FormatRupiah.format(widget.produk.harga * _kuantitas),
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: WarnaAplikasi.aksenMawar,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Pengatur Jumlah (Stepper)
                Container(
                  decoration: BoxDecoration(
                    color: WarnaAplikasi.kremLatar,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: _kurangKuantitas,
                        borderRadius: BorderRadius.circular(8),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.remove, size: 14, color: WarnaAplikasi.coklatMawar),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          '$_kuantitas',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: WarnaAplikasi.coklatMawar,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _tambahKuantitas,
                        borderRadius: BorderRadius.circular(8),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.add, size: 14, color: WarnaAplikasi.coklatMawar),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Tombol Tambah Keranjang
                ElevatedButton(
                  onPressed: widget.produk.stok > 0 ? () => _masukkanKeranjang() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WarnaAplikasi.coklatMawar,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        '+ Keranjang',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // TAMPILAN DESKTOP / WEB (ATELIER DUAL-COLUMN LAYOUT)
  // =========================================================================
  Widget _tampilanDesktop(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb Navigasi
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      'Katalog Bunga',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: WarnaAplikasi.coklatMawar,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, size: 16, color: WarnaAplikasi.teksSekunder),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.produk.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: WarnaAplikasi.teksSekunder,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Two-Column Grid: Kiri Galeri Foto, Kanan Detail & Aksi
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kolom Kiri: Galeri Slider Foto Responsif dengan Thumbnail & Auto Crop
                  Expanded(
                    flex: 6,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: WarnaAplikasi.coklatMawar.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SliderFotoBunga(
                            daftarFoto: widget.produk.semuaFoto,
                            aspectRatio: 1.05,
                            fit: BoxFit.cover,
                            tampilkanThumbnailBawah: true,
                            bisaDiKlikZoom: true,
                            judulProduk: widget.produk.nama,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.touch_app_outlined,
                                size: 14,
                                color: WarnaAplikasi.teksSekunder,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Klik foto atau tombol "Perbesar" untuk melihat kelopak bunga hingga 4.5x zoom',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: WarnaAplikasi.teksSekunder,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 36),

                  // Kolom Kanan: Detail Informasi, Deskripsi, Catatan & Checkout
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tag Kategori & Status Stok (Wrap agar responsif di kolom kanan)
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: WarnaAplikasi.kremLatar,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Text(
                                'Sélection Florale Artisanale',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: WarnaAplikasi.coklatMawar,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: widget.produk.stok > 0
                                    ? WarnaAplikasi.sukses.withValues(alpha: 0.1)
                                    : WarnaAplikasi.bahaya.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.produk.stok > 0
                                    ? 'Stok Tersedia (${widget.produk.stok} buket)'
                                    : 'Stok Kosong',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: widget.produk.stok > 0
                                      ? WarnaAplikasi.sukses
                                      : WarnaAplikasi.bahaya,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Nama Bunga Besar
                        Text(
                          widget.produk.nama,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: WarnaAplikasi.teksUtama,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Harga
                        Text(
                          FormatRupiah.format(widget.produk.harga),
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: WarnaAplikasi.aksenMawar,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Jaminan Kualitas Florist
                        _barisJaminanKualitas(),

                        const SizedBox(height: 20),
                        const Divider(color: WarnaAplikasi.garisBatas),
                        const SizedBox(height: 14),

                        // Deskripsi
                        Text(
                          'Filosofi & Komposisi Rangkaian',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: WarnaAplikasi.teksUtama,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.produk.deskripsi,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: WarnaAplikasi.teksSekunder,
                            height: 1.65,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Catatan Ucapan Personal
                        Text(
                          'Pesan Kartu Ucapan / Catatan Rangkaian',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: WarnaAplikasi.teksUtama,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _catatanKontroller,
                          maxLines: 3,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Tuliskan pesan kartu ucapan kaligrafi atau preferensi khusus rangkaian Anda di sini...',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 36),
                              child: Icon(Icons.edit_note_rounded, color: WarnaAplikasi.coklatMawar),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: WarnaAplikasi.garisBatas),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: WarnaAplikasi.emasKlasik, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Aksi Kuantitas & Tombol Pesan
                        Container(
                          padding: const EdgeInsets.all(18),
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
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Kuantitas:',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: WarnaAplikasi.teksUtama,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: WarnaAplikasi.kremLatar,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          icon: const Icon(Icons.remove, size: 16, color: WarnaAplikasi.coklatMawar),
                                          onPressed: _kurangKuantitas,
                                        ),
                                        Text(
                                          '$_kuantitas',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: WarnaAplikasi.coklatMawar,
                                          ),
                                        ),
                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          icon: const Icon(Icons.add, size: 16, color: WarnaAplikasi.coklatMawar),
                                          onPressed: _tambahKuantitas,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Subtotal',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: WarnaAplikasi.teksSekunder,
                                        ),
                                      ),
                                      Text(
                                        FormatRupiah.format(widget.produk.harga * _kuantitas),
                                        style: GoogleFonts.playfairDisplay(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w900,
                                          color: WarnaAplikasi.aksenMawar,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: widget.produk.stok > 0
                                          ? () => _masukkanKeranjang()
                                          : null,
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        side: const BorderSide(color: WarnaAplikasi.coklatMawar),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      icon: const Icon(Icons.shopping_bag_outlined, color: WarnaAplikasi.coklatMawar, size: 16),
                                      label: Text(
                                        'Tambah ke Keranjang',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.bold,
                                          color: WarnaAplikasi.coklatMawar,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: widget.produk.stok > 0
                                          ? () => _masukkanKeranjang(bukaLaciLangsung: true)
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        backgroundColor: WarnaAplikasi.coklatMawar,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      icon: const Icon(Icons.flash_on_rounded, size: 16),
                                      label: Text(
                                        'Beli Sekarang',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // KOMPONEN JAMINAN KUALITAS ATELIER (RESPONSIF WRAP)
  // =========================================================================
  Widget _barisJaminanKualitas() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WarnaAplikasi.garisBatas),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 8,
        children: [
          _itemJaminan(Icons.verified_outlined, '100% Segar & Asli'),
          _itemJaminan(Icons.draw_outlined, 'Kartu Kaligrafi'),
          _itemJaminan(Icons.local_shipping_outlined, 'Kirim Hari Ini'),
        ],
      ),
    );
  }

  Widget _itemJaminan(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: WarnaAplikasi.emasKlasik),
        const SizedBox(width: 5),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: WarnaAplikasi.teksUtama,
          ),
        ),
      ],
    );
  }
}
