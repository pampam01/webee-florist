import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/autentikasi/presentasi/penyedia/penyedia_autentikasi.dart';
import 'package:webee_florist/fitur/keranjang/presentasi/penyedia/penyedia_keranjang.dart';
import 'package:webee_florist/fitur/pesanan/presentasi/halaman/halaman_checkout.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';
import 'package:webee_florist/inti/utilitas/format_rupiah.dart';
import 'dialog_masuk_cepat.dart';

class LaciKeranjangWeb extends ConsumerWidget {
  const LaciKeranjangWeb({super.key});

  static void buka(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup Keranjang',
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, anim1, anim2) {
        return const Align(
          alignment: Alignment.centerRight,
          child: LaciKeranjangWeb(),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curve),
          child: child,
        );
      },
    );
  }

  void _lanjutCheckout(BuildContext context, WidgetRef ref) {
    final stateAuth = ref.read(autentikasiProvider);

    if (stateAuth.sudahMasuk) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const HalamanCheckout()),
      );
    } else {
      // Belum login: Tampilkan modal login cepat
      DialogMasukCepat.tampilkan(
        context,
        padaBerhasilMasuk: () {
          Navigator.of(context).pop(); // Tutup laci keranjang
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HalamanCheckout()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateKeranjang = ref.watch(keranjangProvider);
    final lebarLayar = MediaQuery.of(context).size.width;
    final lebarLaci = lebarLayar > 500 ? 440.0 : lebarLayar;

    return Material(
      color: Colors.white,
      elevation: 16,
      child: SizedBox(
        width: lebarLaci,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Laci Keranjang
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: WarnaAplikasi.garisBatas)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shopping_bag_outlined, color: WarnaAplikasi.utama),
                        const SizedBox(width: 10),
                        Text(
                          'Keranjang Belanja (${stateKeranjang.totalItem})',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: WarnaAplikasi.utama,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Daftar Item Keranjang
              Expanded(
                child: stateKeranjang.items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: WarnaAplikasi.latarBelakang,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: WarnaAplikasi.garisBatas),
                                ),
                                child: const Icon(
                                  Icons.local_florist_outlined,
                                  size: 40,
                                  color: WarnaAplikasi.utama,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Keranjang Anda Masih Kosong',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: WarnaAplikasi.teksUtama,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Pilihlah buket bunga klasik istimewa dari galeri kami untuk orang tercinta.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: WarnaAplikasi.teksSekunder,
                                ),
                              ),
                              const SizedBox(height: 20),
                              OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Mulai Pilih Bunga'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: stateKeranjang.items.length,
                        separatorBuilder: (_, __) => const Divider(height: 24),
                        itemBuilder: (context, index) {
                          final item = stateKeranjang.items[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 72,
                                  height: 72,
                                  child: item.produk?.urlGambar != null &&
                                          item.produk!.urlGambar!.isNotEmpty
                                      ? Image.network(
                                          item.produk!.urlGambar!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(
                                            color: WarnaAplikasi.latarBelakang,
                                            child: const Icon(
                                              Icons.local_florist_outlined,
                                              color: WarnaAplikasi.utama,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          color: WarnaAplikasi.latarBelakang,
                                          child: const Icon(
                                            Icons.local_florist_outlined,
                                            color: WarnaAplikasi.utama,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.produk?.nama ?? 'Buket Bunga Webee',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: WarnaAplikasi.teksUtama,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      FormatRupiah.format(item.produk?.harga ?? 0),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: WarnaAplikasi.utama,
                                      ),
                                    ),
                                    if (item.catatanKhusus != null && item.catatanKhusus!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          'Catatan: ${item.catatanKhusus}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: WarnaAplikasi.teksSekunder,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // Kuantitas & Hapus
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    iconSize: 18,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                                    onPressed: () {
                                      ref.read(keranjangProvider.notifier).hapusItem(item.id);
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: WarnaAplikasi.latarBelakang,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: WarnaAplikasi.garisBatas),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            ref.read(keranjangProvider.notifier).perbaruiKuantitas(
                                                  item.id,
                                                  item.kuantitas - 1,
                                                );
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                            child: Icon(Icons.remove, size: 14),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 6),
                                          child: Text(
                                            '${item.kuantitas}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            ref.read(keranjangProvider.notifier).perbaruiKuantitas(
                                                  item.id,
                                                  item.kuantitas + 1,
                                                );
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                            child: Icon(Icons.add, size: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
              ),

              // Ringkasan Pembayaran & Tombol Checkout
              if (stateKeranjang.items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: WarnaAplikasi.latarBelakang,
                    border: const Border(top: BorderSide(color: WarnaAplikasi.garisBatas)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal Rangkaian Bunga:'),
                          Text(
                            FormatRupiah.format(stateKeranjang.totalHarga),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estimasi Kurir Pendingin:', style: TextStyle(fontSize: 12, color: WarnaAplikasi.teksSekunder)),
                          Text('Dihitung saat checkout', style: TextStyle(fontSize: 12, color: WarnaAplikasi.teksSekunder)),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Pembelian:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            FormatRupiah.format(stateKeranjang.totalHarga),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: WarnaAplikasi.utama,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _lanjutCheckout(context, ref),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Lanjut ke Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 16),
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
      ),
    );
  }
}
