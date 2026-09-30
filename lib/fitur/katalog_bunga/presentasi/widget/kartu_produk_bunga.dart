import 'package:flutter/material.dart';
import 'package:webee_florist/fitur/katalog_bunga/data/model/produk_model.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';
import 'package:webee_florist/inti/utilitas/format_rupiah.dart';

class KartuProdukBunga extends StatelessWidget {
  final ProdukBungaModel produk;
  final VoidCallback padaKetuk;
  final VoidCallback padaTambahKeranjang;

  const KartuProdukBunga({
    super.key,
    required this.produk,
    required this.padaKetuk,
    required this.padaTambahKeranjang,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: padaKetuk,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WarnaAplikasi.garisBatas),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Gambar
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: produk.urlGambar != null && produk.urlGambar!.isNotEmpty
                          ? Image.network(
                              produk.urlGambar!,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                color: Colors.grey.shade100,
                                child: const Center(
                                  child: Icon(
                                    Icons.local_florist,
                                    size: 48,
                                    color: WarnaAplikasi.utama,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.grey.shade100,
                              child: const Center(
                                child: Icon(
                                  Icons.local_florist,
                                  size: 48,
                                  color: WarnaAplikasi.utama,
                                ),
                              ),
                            ),
                    ),
                  ),
                  // Badge Stok / Ketersediaan
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: produk.stok > 0
                            ? WarnaAplikasi.utama.withValues(alpha: 0.9)
                            : WarnaAplikasi.bahaya.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        produk.stok > 0 ? 'Sisa ${produk.stok}' : 'Habis',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bagian Detail Informasi
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: WarnaAplikasi.teksUtama,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    FormatRupiah.format(produk.harga),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: WarnaAplikasi.utama,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: produk.stok > 0 ? padaTambahKeranjang : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: WarnaAplikasi.utama,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 14),
                          SizedBox(width: 4),
                          Text(
                            '+ Keranjang',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
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
