import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/admin/presentasi/halaman/halaman_dashboard_admin.dart';
import 'package:webee_florist/fitur/autentikasi/presentasi/penyedia/penyedia_autentikasi.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/halaman/halaman_katalog_bunga.dart';
import 'package:webee_florist/fitur/keranjang/presentasi/penyedia/penyedia_keranjang.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';
import 'dialog_masuk_cepat.dart';
import 'laci_keranjang_web.dart';

class BilahNavigasiAtas extends ConsumerWidget {
  final Function(int indeksSeksi)? padaPilihSeksi;

  const BilahNavigasiAtas({super.key, this.padaPilihSeksi});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAuth = ref.watch(autentikasiProvider);
    final stateKeranjang = ref.watch(keranjangProvider);
    final lebarLayar = MediaQuery.of(context).size.width;
    final adalahDesktop = lebarLayar >= 960;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pita Pengumuman Atas (Announcement Bar)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: WarnaAplikasi.utama,
          child: const Text(
            'Pengiriman Rangkaian Bunga Segar Setiap Hari • Kartu Ucapan Kaligrafi Personal • Atelier by Utiy',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
            ),
          ),
        ),

        // Header Utama Web
        Container(
          width: double.infinity,
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            border: const Border(
              bottom: BorderSide(color: WarnaAplikasi.garisBatas, width: 1.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bagian Kiri: Logo Webee Florist
              InkWell(
                onTap: () => padaPilihSeksi?.call(0),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Image.asset(
                    'assets/logo/logo_webee_horizontal.png',
                    height: 48,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, err, stack) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_florist, color: WarnaAplikasi.utama, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          'WEBEE Florist by utiy',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: WarnaAplikasi.utama,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bagian Tengah: Tautan Menu Navigasi (Tampil di Desktop)
              if (adalahDesktop)
                Row(
                  children: [
                    _itemMenuNavigasi(context, 'Beranda', () => padaPilihSeksi?.call(0)),
                    _itemMenuNavigasi(context, 'Koleksi Bunga', () => padaPilihSeksi?.call(1)),
                    _itemMenuNavigasi(
                      context,
                      'Katalog',
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HalamanKatalogBunga()),
                      ),
                    ),
                    _itemMenuNavigasi(context, 'Filosofi', () => padaPilihSeksi?.call(3)),
                    _itemMenuNavigasi(context, 'Keunggulan', () => padaPilihSeksi?.call(4)),
                    _itemMenuNavigasi(context, 'Ulasan', () => padaPilihSeksi?.call(5)),
                    _itemMenuNavigasi(context, 'Kontak', () => padaPilihSeksi?.call(6)),
                  ],
                ),

              // Bagian Kanan: Aksi Keranjang & Akun
              Row(
                children: [
                  // Tombol Keranjang Belanja
                  IconButton(
                    tooltip: 'Keranjang Belanja',
                    icon: Badge(
                      isLabelVisible: stateKeranjang.totalItem > 0,
                      backgroundColor: WarnaAplikasi.utama,
                      label: Text('${stateKeranjang.totalItem}'),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: WarnaAplikasi.teksUtama,
                      ),
                    ),
                    onPressed: () => LaciKeranjangWeb.buka(context),
                  ),
                  const SizedBox(width: 12),

                  // Tombol Status Akun
                  if (stateAuth.sudahMasuk) ...[
                    if (stateAuth.isAdmin)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const HalamanDashboardAdmin(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.admin_panel_settings, size: 16),
                          label: const Text('Panel Admin', style: TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                    PopupMenuButton<String>(
                      tooltip: 'Menu Akun',
                      offset: const Offset(0, 48),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: WarnaAplikasi.latarBelakang,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: WarnaAplikasi.garisBatas),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: WarnaAplikasi.utama,
                              child: Text(
                                (stateAuth.pengguna?.nama.isNotEmpty == true
                                        ? stateAuth.pengguna!.nama[0]
                                        : 'U')
                                    .toUpperCase(),
                                style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              stateAuth.pengguna?.nama.split(' ').first ?? 'Akun',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: WarnaAplikasi.teksUtama,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 18, color: WarnaAplikasi.teksSekunder),
                          ],
                        ),
                      ),
                      onSelected: (aksi) async {
                        if (aksi == 'keluar') {
                          await ref.read(autentikasiProvider.notifier).keluar();
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          enabled: false,
                          child: Text(
                            stateAuth.pengguna?.email ?? '',
                            style: const TextStyle(fontSize: 12, color: WarnaAplikasi.teksSekunder),
                          ),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem(
                          value: 'keluar',
                          child: Row(
                            children: [
                              Icon(Icons.logout, size: 16, color: WarnaAplikasi.bahaya),
                              SizedBox(width: 8),
                              Text('Keluar Sesi', style: TextStyle(fontSize: 13, color: WarnaAplikasi.bahaya)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: () => DialogMasukCepat.tampilkan(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      ),
                      child: const Text('Masuk'),
                    ),
                  ],

                  // Tombol Drawer untuk Layar Mobile
                  if (!adalahDesktop)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Builder(
                        builder: (ctx) => IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _itemMenuNavigasi(BuildContext context, String judul, VoidCallback padaTekan) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: padaTekan,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Text(
            judul,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: WarnaAplikasi.teksUtama,
            ),
          ),
        ),
      ),
    );
  }
}
