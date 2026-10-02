import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webee_florist/fitur/pesanan/presentasi/penyedia/penyedia_pesanan.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class ItemMenuSidebar {
  final int indeks;
  final String judul;
  final IconData ikon;
  final bool punyaBadge;

  const ItemMenuSidebar({
    required this.indeks,
    required this.judul,
    required this.ikon,
    this.punyaBadge = false,
  });
}

class BilahSisiAdmin extends ConsumerWidget {
  final int indeksTerpilih;
  final ValueChanged<int> onPilihIndeks;
  final VoidCallback? onTutupDrawer;

  const BilahSisiAdmin({
    super.key,
    required this.indeksTerpilih,
    required this.onPilihIndeks,
    this.onTutupDrawer,
  });

  static const List<ItemMenuSidebar> _daftarMenu = [
    ItemMenuSidebar(
      indeks: 0,
      judul: 'Ringkasan & Analitik',
      ikon: Icons.insights_outlined,
    ),
    ItemMenuSidebar(
      indeks: 1,
      judul: 'Pesanan & Logistik',
      ikon: Icons.local_shipping_outlined,
      punyaBadge: true,
    ),
    ItemMenuSidebar(
      indeks: 2,
      judul: 'Katalog Produk',
      ikon: Icons.local_florist_outlined,
    ),
    ItemMenuSidebar(
      indeks: 3,
      judul: 'Pelanggan & CRM',
      ikon: Icons.people_outline,
    ),
    ItemMenuSidebar(
      indeks: 4,
      judul: 'Laporan & Ekspor',
      ikon: Icons.analytics_outlined,
    ),
    ItemMenuSidebar(
      indeks: 5,
      judul: 'Pengaturan Toko',
      ikon: Icons.settings_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pesananAsync = ref.watch(daftarPesananAdminProvider);
    final jumlahPesananAktif = pesananAsync.maybeWhen(
      data: (list) => list.where((p) => p.status != 'selesai' && p.status != 'dibatalkan').length,
      orElse: () => 2,
    );

    return Container(
      width: 270,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: WarnaAplikasi.garisBatas)),
      ),
      child: Column(
        children: [
          // Header Sidebar (Logo & Identitas Brand)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: WarnaAplikasi.garisBatas)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: WarnaAplikasi.gradienUtama,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: WarnaAplikasi.utama.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'W',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: WarnaAplikasi.aksenEmas,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Webee Florist',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: WarnaAplikasi.utama,
                        ),
                      ),
                      const Text(
                        'by utiy • Admin Portal',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: WarnaAplikasi.aksenEmas,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Daftar Item Menu Sidebar
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 8),
                  child: Text(
                    'NAVIGASI OPERASIONAL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: WarnaAplikasi.teksRedup,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                ..._daftarMenu.map((menu) {
                  final terpilih = indeksTerpilih == menu.indeks;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          onPilihIndeks(menu.indeks);
                          onTutupDrawer?.call();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: terpilih ? WarnaAplikasi.utama : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: terpilih
                                ? [
                                    BoxShadow(
                                      color: WarnaAplikasi.utama.withValues(alpha: 0.25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                menu.ikon,
                                size: 19,
                                color: terpilih ? WarnaAplikasi.aksenEmas : WarnaAplikasi.teksSekunder,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  menu.judul,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: terpilih ? FontWeight.bold : FontWeight.w500,
                                    color: terpilih ? Colors.white : WarnaAplikasi.teksUtama,
                                  ),
                                ),
                              ),
                              if (menu.punyaBadge && jumlahPesananAktif > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: terpilih ? WarnaAplikasi.aksenEmas : WarnaAplikasi.aksenMawar,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$jumlahPesananAktif',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: terpilih ? WarnaAplikasi.utama : Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Footer Sidebar (Profil Admin & Kembali ke Web)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: WarnaAplikasi.garisBatas)),
            ),
            child: Column(
              children: [
                // Info Profil Admin
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: WarnaAplikasi.latarBelakang,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: WarnaAplikasi.garisBatas),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: WarnaAplikasi.aksenMerahMuda,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_pin, color: WarnaAplikasi.utama, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'utiy (Florist Master)',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: WarnaAplikasi.teksUtama),
                            ),
                            Text(
                              'Administrator Utama',
                              style: TextStyle(fontSize: 10, color: WarnaAplikasi.teksSekunder),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Tombol Kembali ke Toko Web
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: WarnaAplikasi.utama,
                    side: const BorderSide(color: WarnaAplikasi.garisBatas),
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  icon: const Icon(Icons.storefront_outlined, size: 16),
                  label: const Text('Buka Beranda Toko', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
