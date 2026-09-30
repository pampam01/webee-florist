import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/pesanan/presentasi/penyedia/penyedia_pesanan.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';
import 'package:webee_florist/inti/utilitas/format_rupiah.dart';

class HalamanRiwayatPesanan extends ConsumerWidget {
  const HalamanRiwayatPesanan({super.key});

  Color _warnaStatus(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu_pembayaran':
        return WarnaAplikasi.peringatan;
      case 'diproses':
        return WarnaAplikasi.info;
      case 'dikirim':
        return Colors.indigo;
      case 'selesai':
        return WarnaAplikasi.sukses;
      case 'dibatalkan':
        return WarnaAplikasi.bahaya;
      default:
        return Colors.grey;
    }
  }

  String _labelStatus(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu_pembayaran':
        return 'Menunggu Bayar';
      case 'diproses':
        return 'Sedang Dirangkai';
      case 'dikirim':
        return 'Dalam Pengiriman';
      case 'selesai':
        return 'Pesanan Tiba';
      case 'dibatalkan':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riwayatAsync = ref.watch(riwayatPesananProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(riwayatPesananProvider);
        },
        child: riwayatAsync.when(
          data: (pesananList) {
            if (pesananList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada riwayat pesanan',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pesananList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final pesanan = pesananList[index];
                final warna = _warnaStatus(pesanan.status);

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: WarnaAplikasi.garisBatas),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pesanan.nomorPesanan,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: WarnaAplikasi.utama,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: warna.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _labelStatus(pesanan.status),
                              style: TextStyle(
                                color: warna,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Waktu: ${pesanan.stempelWaktu ?? "-"}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const Divider(height: 18),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, size: 16, color: WarnaAplikasi.utama),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Penerima: ${pesanan.namaPenerima} (${pesanan.teleponPenerima})\n${pesanan.alamatPengiriman}',
                              style: const TextStyle(fontSize: 12, color: WarnaAplikasi.teksUtama),
                            ),
                          ),
                        ],
                      ),

                      if (pesanan.pesanKartuUcapan != null && pesanan.pesanKartuUcapan!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.pink.shade50.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.favorite, size: 14, color: Colors.pink),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '"${pesanan.pesanKartuUcapan}"',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.pink.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Metode: ${pesanan.metodePembayaran ?? "QRIS"}',
                            style: const TextStyle(fontSize: 12, color: WarnaAplikasi.teksSekunder),
                          ),
                          Text(
                            FormatRupiah.format(pesanan.grandTotal),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: WarnaAplikasi.utama,
                            ),
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
          error: (err, _) => Center(child: Text('Gagal memuat: $err')),
        ),
      ),
    );
  }
}
