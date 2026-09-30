import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/katalog_bunga/data/model/produk_model.dart';
import 'package:webee_florist/fitur/keranjang/presentasi/penyedia/penyedia_keranjang.dart';
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

  Future<void> _masukkanKeranjang() async {
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
          content: Text('$_kuantitas x ${widget.produk.nama} berhasil ditambahkan ke keranjang'),
          backgroundColor: WarnaAplikasi.sukses,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Rangkaian Bunga'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk
            SizedBox(
              height: 300,
              width: double.infinity,
              child: widget.produk.urlGambar != null && widget.produk.urlGambar!.isNotEmpty
                  ? Image.network(
                      widget.produk.urlGambar!,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: Colors.grey.shade100,
                        child: const Icon(
                          Icons.local_florist,
                          size: 72,
                          color: WarnaAplikasi.utama,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade100,
                      child: const Icon(
                        Icons.local_florist,
                        size: 72,
                        color: WarnaAplikasi.utama,
                      ),
                    ),
            ),

            // Informasi Produk
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: WarnaAplikasi.utama.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Sélection Florale Artisanale',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: WarnaAplikasi.utama,
                          ),
                        ),
                      ),
                      Text(
                        'Stok: ${widget.produk.stok} buket',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: widget.produk.stok > 0
                              ? WarnaAplikasi.sukses
                              : WarnaAplikasi.bahaya,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nama Bunga
                  Text(
                    widget.produk.nama,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: WarnaAplikasi.teksUtama,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Harga
                  Text(
                    FormatRupiah.format(widget.produk.harga),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: WarnaAplikasi.utama,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Deskripsi
                  const Text(
                    'Deskripsi Rangkaian',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: WarnaAplikasi.teksUtama,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.produk.deskripsi,
                    style: const TextStyle(
                      fontSize: 14,
                      color: WarnaAplikasi.teksSekunder,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Permintaan Khusus / Catatan
                  TextField(
                    controller: _catatanKontroller,
                    decoration: const InputDecoration(
                      labelText: 'Catatan Khusus Florist (Opsional)',
                      hintText: 'Contoh: Tambah pita warna merah, kirim sebelum siang',
                      prefixIcon: Icon(Icons.note_alt_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pengatur Kuantitas & Tombol Tambah
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: WarnaAplikasi.garisBatas),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _kurangKuantitas,
                              icon: const Icon(Icons.remove, size: 18),
                            ),
                            Text(
                              '$_kuantitas',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: _tambahKuantitas,
                              icon: const Icon(Icons.add, size: 18),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.produk.stok > 0 ? _masukkanKeranjang : null,
                          child: const Text('Masukkan Keranjang'),
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
    );
  }
}
