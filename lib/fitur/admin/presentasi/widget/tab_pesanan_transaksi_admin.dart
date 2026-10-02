import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/fitur/admin/presentasi/widget/badge_urgensi_pengantaran.dart';
import 'package:webee_florist/fitur/admin/presentasi/widget/dialog_atur_logistik_kurir.dart';
import 'package:webee_florist/fitur/admin/presentasi/widget/dialog_kartu_ucapan_admin.dart';
import 'package:webee_florist/fitur/pesanan/data/model/pesanan_model.dart';
import 'package:webee_florist/fitur/pesanan/presentasi/penyedia/penyedia_pesanan.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';
import 'package:webee_florist/inti/utilitas/format_rupiah.dart';

class TabPesananTransaksiAdmin extends ConsumerStatefulWidget {
  const TabPesananTransaksiAdmin({super.key});

  @override
  ConsumerState<TabPesananTransaksiAdmin> createState() =>
      _TabPesananTransaksiAdminState();
}

class _TabPesananTransaksiAdminState
    extends ConsumerState<TabPesananTransaksiAdmin> {
  final TextEditingController _kontrolerCari = TextEditingController();

  @override
  void dispose() {
    _kontrolerCari.dispose();
    super.dispose();
  }

  void _tampilkanDialogKonfirmasi({
    required String judul,
    required String pesan,
    required String labelAksi,
    required Color warnaAksi,
    required VoidCallback onKonfirmasi,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          judul,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: WarnaAplikasi.teksUtama,
          ),
        ),
        content: Text(
          pesan,
          style: const TextStyle(fontSize: 13, color: WarnaAplikasi.teksSekunder),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: warnaAksi,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              onKonfirmasi();
            },
            child: Text(labelAksi),
          ),
        ],
      ),
    );
  }

  Widget _buatBadgeStatus(String status) {
    Color bg;
    Color teks;
    String label;
    IconData ikon;

    switch (status) {
      case 'menunggu_pembayaran':
        bg = WarnaAplikasi.peringatan.withValues(alpha: 0.12);
        teks = WarnaAplikasi.peringatan;
        label = 'Menunggu Pembayaran';
        ikon = Icons.hourglass_top_outlined;
        break;
      case 'diproses':
        bg = WarnaAplikasi.info.withValues(alpha: 0.12);
        teks = WarnaAplikasi.info;
        label = 'Dirangkai Florist';
        ikon = Icons.brush_outlined;
        break;
      case 'dikirim':
        bg = WarnaAplikasi.aksenMawar.withValues(alpha: 0.15);
        teks = WarnaAplikasi.utama;
        label = 'Sedang Dikirim';
        ikon = Icons.local_shipping_outlined;
        break;
      case 'selesai':
        bg = WarnaAplikasi.sukses.withValues(alpha: 0.12);
        teks = WarnaAplikasi.sukses;
        label = 'Tuntas Diterima';
        ikon = Icons.check_circle_outline;
        break;
      case 'dibatalkan':
        bg = WarnaAplikasi.bahaya.withValues(alpha: 0.12);
        teks = WarnaAplikasi.bahaya;
        label = 'Dibatalkan';
        ikon = Icons.cancel_outlined;
        break;
      default:
        bg = WarnaAplikasi.garisBatas;
        teks = WarnaAplikasi.teksSekunder;
        label = status;
        ikon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: teks.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 12, color: teks),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: teks,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buatBadgeModaKurir(String? jenis) {
    if (jenis == null || jenis.isEmpty) return const SizedBox.shrink();

    String label;
    IconData ikon;

    switch (jenis) {
      case 'armada_mobil_berpendingin':
        label = 'Mobil Berpendingin';
        ikon = Icons.ac_unit;
        break;
      case 'kurir_motor_florist':
        label = 'Motor Florist';
        ikon = Icons.two_wheeler;
        break;
      case 'kurir_eksternal_instan':
        label = 'Kurir Instan';
        ikon = Icons.delivery_dining;
        break;
      default:
        label = 'Kurir Florist';
        ikon = Icons.local_shipping;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: WarnaAplikasi.aksenMerahMuda,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WarnaAplikasi.utama.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 12, color: WarnaAplikasi.utama),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: WarnaAplikasi.utama,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buatItemFilterChip({
    required String nilai,
    required String label,
    required String statusTerpilih,
  }) {
    final terpilih = statusTerpilih == nilai;
    return ChoiceChip(
      label: Text(label),
      selected: terpilih,
      selectedColor: WarnaAplikasi.utama,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: terpilih ? FontWeight.bold : FontWeight.w500,
        color: terpilih ? Colors.white : WarnaAplikasi.teksUtama,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: terpilih ? WarnaAplikasi.utama : WarnaAplikasi.garisBatas,
        ),
      ),
      onSelected: (_) {
        ref.read(filterStatusPesananAdminProvider.notifier).state = nilai;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterStatus = ref.watch(filterStatusPesananAdminProvider);
    final pesananAsync = ref.watch(daftarPesananAdminProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bar Pencarian & Penyegaran Data
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: WarnaAplikasi.garisBatas),
                ),
                child: TextField(
                  controller: _kontrolerCari,
                  decoration: InputDecoration(
                    hintText: 'Cari nomor pesanan, penerima, no. telepon, alamat...',
                    hintStyle: const TextStyle(fontSize: 13, color: WarnaAplikasi.teksRedup),
                    prefixIcon: const Icon(Icons.search, size: 18, color: WarnaAplikasi.teksSekunder),
                    suffixIcon: _kontrolerCari.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _kontrolerCari.clear();
                              ref.read(kataKunciCariAdminProvider.notifier).state = '';
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  onSubmitted: (val) {
                    ref.read(kataKunciCariAdminProvider.notifier).state = val;
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: WarnaAplikasi.garisBatas),
                ),
              ),
              icon: const Icon(Icons.refresh, color: WarnaAplikasi.utama),
              tooltip: 'Perbarui Data Pesanan',
              onPressed: () {
                ref.invalidate(daftarPesananAdminProvider);
              },
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Filter Bar Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buatItemFilterChip(nilai: 'semua', label: 'Semua Pesanan', statusTerpilih: filterStatus),
              const SizedBox(width: 8),
              _buatItemFilterChip(nilai: 'menunggu_pembayaran', label: 'Menunggu Bayar', statusTerpilih: filterStatus),
              const SizedBox(width: 8),
              _buatItemFilterChip(nilai: 'diproses', label: 'Dirangkai Florist', statusTerpilih: filterStatus),
              const SizedBox(width: 8),
              _buatItemFilterChip(nilai: 'dikirim', label: 'Sedang Dikirim', statusTerpilih: filterStatus),
              const SizedBox(width: 8),
              _buatItemFilterChip(nilai: 'selesai', label: 'Tuntas Diterima', statusTerpilih: filterStatus),
              const SizedBox(width: 8),
              _buatItemFilterChip(nilai: 'dibatalkan', label: 'Dibatalkan', statusTerpilih: filterStatus),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Daftar Pesanan
        pesananAsync.when(
          data: (daftar) {
            if (daftar.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: WarnaAplikasi.garisBatas),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.inbox_outlined,
                      size: 48,
                      color: WarnaAplikasi.teksRedup,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tidak ada pesanan ditemukan',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: WarnaAplikasi.teksUtama,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Silakan sesuaikan kata kunci pencarian atau ganti filter status di atas.',
                      style: TextStyle(fontSize: 12, color: WarnaAplikasi.teksSekunder),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: daftar.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final p = daftar[index];
                return _buatKartuPesanan(p);
              },
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, _) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('Terjadi kesalahan memuat pesanan: $err'),
          ),
        ),
      ],
    );
  }

  Widget _buatKartuPesanan(PesananModel p) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WarnaAplikasi.garisBatas),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Kartu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: WarnaAplikasi.latarBelakang,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: const Border(bottom: BorderSide(color: WarnaAplikasi.garisBatas)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '#${p.nomorPesanan}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: WarnaAplikasi.utama,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buatBadgeModaKurir(p.jenisKurir),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Waktu Masuk: ${p.stempelWaktu ?? '-'}',
                      style: const TextStyle(fontSize: 11, color: WarnaAplikasi.teksSekunder),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    BadgeUrgensiPengantaran(
                      tanggalKirim: p.tanggalKirim,
                      estimasiJam: p.estimasiJamKirim,
                    ),
                    _buatBadgeStatus(p.status),
                  ],
                ),
              ],
            ),
          ),

          // Isi Kartu
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Penerima & Alamat
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 18, color: WarnaAplikasi.utama),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                p.namaPenerima,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: WarnaAplikasi.teksUtama,
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: p.teleponPenerima));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Nomor telepon ${p.teleponPenerima} disalin')),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: WarnaAplikasi.latarBelakang,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: WarnaAplikasi.garisBatas),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.phone, size: 10, color: WarnaAplikasi.teksSekunder),
                                      const SizedBox(width: 4),
                                      Text(
                                        p.teleponPenerima,
                                        style: const TextStyle(fontSize: 11, color: WarnaAplikasi.teksSekunder),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.alamatPengiriman,
                            style: const TextStyle(fontSize: 12, color: WarnaAplikasi.teksSekunder),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(color: WarnaAplikasi.garisBatas),
                const SizedBox(height: 8),

                // Daftar Item Pesanan
                ...p.itemPesanan.map((item) {
                  final namaProduk = item.namaProdukSnapshot ?? item.produk?.nama ?? 'Rangkaian Bunga';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '• $namaProduk x ${item.kuantitas}',
                            style: const TextStyle(fontSize: 12, color: WarnaAplikasi.teksUtama),
                          ),
                        ),
                        Text(
                          FormatRupiah.format(item.subtotal),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 10),

                // Informasi Logistik Jika Ada
                if (p.namaKurir != null && p.namaKurir!.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: WarnaAplikasi.latarBelakang,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: WarnaAplikasi.garisBatas),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.badge_outlined, size: 16, color: WarnaAplikasi.utama),
                            const SizedBox(width: 6),
                            Text(
                              'Driver: ${p.namaKurir} (${p.teleponKurir ?? '-'})',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Text(
                          'Resi: ${p.nomorResi ?? '-'}',
                          style: const TextStyle(fontSize: 11, color: WarnaAplikasi.teksSekunder),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                // Total Pembayaran
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Metode: ${p.metodePembayaran ?? 'QRIS'}',
                      style: const TextStyle(fontSize: 11, color: WarnaAplikasi.teksSekunder),
                    ),
                    Row(
                      children: [
                        const Text('Total: ', style: TextStyle(fontSize: 12, color: WarnaAplikasi.teksSekunder)),
                        Text(
                          FormatRupiah.format(p.grandTotal),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: WarnaAplikasi.utama,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Footer Tombol Alur Kerja Pesanan
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: WarnaAplikasi.garisBatas)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Tombol Kartu Ucapan & WA
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: WarnaAplikasi.utama,
                    side: const BorderSide(color: WarnaAplikasi.utama),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => DialogKartuUcapanAdmin(pesanan: p),
                    );
                  },
                  icon: const Icon(Icons.card_membership_outlined, size: 14),
                  label: const Text('Kartu Ucapan & WA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),

                // Tombol Alur Status Dinamis
                Wrap(
                  spacing: 6,
                  children: [
                    if (p.status == 'menunggu_pembayaran') ...[
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: WarnaAplikasi.bahaya,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        onPressed: () {
                          _tampilkanDialogKonfirmasi(
                            judul: 'Batalkan Pesanan #${p.nomorPesanan}',
                            pesan: 'Apakah Anda yakin ingin membatalkan transaksi pesanan ini?',
                            labelAksi: 'Batalkan Pesanan',
                            warnaAksi: WarnaAplikasi.bahaya,
                            onKonfirmasi: () {
                              ref
                                  .read(aksiPesananAdminProvider.notifier)
                                  .ubahStatusDanLogistik(pesananId: p.id, statusBaru: 'dibatalkan');
                            },
                          );
                        },
                        child: const Text('Batalkan', style: TextStyle(fontSize: 11)),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: WarnaAplikasi.utama,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          ref
                              .read(aksiPesananAdminProvider.notifier)
                              .ubahStatusDanLogistik(pesananId: p.id, statusBaru: 'diproses');
                        },
                        icon: const Icon(Icons.check, size: 14),
                        label: const Text('Terima & Rangkai', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],

                    if (p.status == 'diproses') ...[
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: WarnaAplikasi.aksenMawar,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => DialogAturLogistikKurir(
                              pesanan: p,
                              ubahStatusKeKirim: true,
                            ),
                          );
                        },
                        icon: const Icon(Icons.local_shipping, size: 14),
                        label: const Text('Atur Logistik & Kirim', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],

                    if (p.status == 'dikirim') ...[
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: WarnaAplikasi.utama,
                          side: const BorderSide(color: WarnaAplikasi.garisBatas),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => DialogAturLogistikKurir(
                              pesanan: p,
                              ubahStatusKeKirim: false,
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_outlined, size: 14),
                        label: const Text('Ubah Kurir', style: TextStyle(fontSize: 11)),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: WarnaAplikasi.sukses,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          _tampilkanDialogKonfirmasi(
                            judul: 'Tandai Pesanan Selesai',
                            pesan: 'Konfirmasi bahwa buket bunga telah diterima dengan baik oleh penerima (${p.namaPenerima})?',
                            labelAksi: 'Konfirmasi Tuntas',
                            warnaAksi: WarnaAplikasi.sukses,
                            onKonfirmasi: () {
                              ref
                                  .read(aksiPesananAdminProvider.notifier)
                                  .ubahStatusDanLogistik(pesananId: p.id, statusBaru: 'selesai');
                            },
                          );
                        },
                        icon: const Icon(Icons.done_all, size: 14),
                        label: const Text('Tandai Selesai', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],

                    if (p.status == 'selesai') ...[
                      const Row(
                        children: [
                          Icon(Icons.verified, size: 16, color: WarnaAplikasi.sukses),
                          SizedBox(width: 4),
                          Text(
                            'Pesanan Tuntas Diantar',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: WarnaAplikasi.sukses,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
