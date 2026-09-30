import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/admin/presentasi/halaman/halaman_dashboard_admin.dart';
import 'package:webee_florist/fitur/autentikasi/presentasi/penyedia/penyedia_autentikasi.dart';
import 'package:webee_florist/fitur/katalog_bunga/presentasi/halaman/halaman_beranda.dart';
import 'package:webee_florist/fitur/keranjang/presentasi/halaman/halaman_keranjang.dart';
import 'package:webee_florist/fitur/keranjang/presentasi/penyedia/penyedia_keranjang.dart';
import 'package:webee_florist/fitur/pesanan/presentasi/halaman/halaman_riwayat_pesanan.dart';
import 'package:webee_florist/fitur/profil/presentasi/halaman/halaman_profil.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

final indeksNavigasiProvider = StateProvider<int>((ref) => 0);

class NavigasiUtama extends ConsumerWidget {
  const NavigasiUtama({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAuth = ref.watch(autentikasiProvider);
    final stateKeranjang = ref.watch(keranjangProvider);
    final indeksAktif = ref.watch(indeksNavigasiProvider);

    final isAdmin = stateAuth.isAdmin;

    final List<Widget> halamanList = [
      const HalamanBeranda(),
      const HalamanKeranjang(),
      const HalamanRiwayatPesanan(),
      if (isAdmin) const HalamanDashboardAdmin(),
      const HalamanProfil(),
    ];

    final List<BottomNavigationBarItem> menuItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.local_florist_outlined),
        activeIcon: Icon(Icons.local_florist),
        label: 'Beranda',
      ),
      BottomNavigationBarItem(
        icon: Badge(
          isLabelVisible: stateKeranjang.totalItem > 0,
          label: Text('${stateKeranjang.totalItem}'),
          child: const Icon(Icons.shopping_bag_outlined),
        ),
        activeIcon: Badge(
          isLabelVisible: stateKeranjang.totalItem > 0,
          label: Text('${stateKeranjang.totalItem}'),
          child: const Icon(Icons.shopping_bag),
        ),
        label: 'Keranjang',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long_outlined),
        activeIcon: Icon(Icons.receipt_long),
        label: 'Pesanan',
      ),
      if (isAdmin)
        const BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings_outlined),
          activeIcon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profil',
      ),
    ];

    final indeksAman = indeksAktif >= halamanList.length ? 0 : indeksAktif;

    return Scaffold(
      body: IndexedStack(
        index: indeksAman,
        children: halamanList,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: WarnaAplikasi.garisBatas, width: 0.8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: indeksAman,
          onTap: (index) {
            ref.read(indeksNavigasiProvider.notifier).state = index;
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: WarnaAplikasi.utama,
          unselectedItemColor: WarnaAplikasi.teksSekunder,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          elevation: 0,
          items: menuItems,
        ),
      ),
    );
  }
}
