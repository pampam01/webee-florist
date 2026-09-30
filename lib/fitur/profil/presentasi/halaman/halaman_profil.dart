import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/autentikasi/presentasi/penyedia/penyedia_autentikasi.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class HalamanProfil extends ConsumerWidget {
  const HalamanProfil({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAuth = ref.watch(autentikasiProvider);
    final pengguna = stateAuth.pengguna;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun & Pengaturan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Kartu Profil Pengguna
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: WarnaAplikasi.garisBatas),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: WarnaAplikasi.utama.withValues(alpha: 0.1),
                    child: Text(
                      (pengguna?.nama.isNotEmpty == true ? pengguna!.nama[0] : 'W').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: WarnaAplikasi.utama,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pengguna?.nama ?? 'Tamu Terhormat',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: WarnaAplikasi.teksUtama,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pengguna?.email ?? 'tamu@webee-florist.com',
                          style: const TextStyle(fontSize: 12, color: WarnaAplikasi.teksSekunder),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: pengguna?.isAdmin == true
                                ? WarnaAplikasi.aksenEmas.withValues(alpha: 0.15)
                                : WarnaAplikasi.utama.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            pengguna?.isAdmin == true ? 'Role: Administrator' : 'Role: Pelanggan',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: pengguna?.isAdmin == true
                                  ? const Color(0xFFB8860B)
                                  : WarnaAplikasi.utama,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Fitur Khusus: Ganti Peran Instan (Demo Mode)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.swap_horiz, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Simulasi Peran Pengguna (Role Switcher)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Anda dapat berganti peran secara instan untuk menguji tampilan antarmuka Admin maupun Pelanggan tanpa login ulang.',
                    style: TextStyle(fontSize: 11, color: Colors.brown),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ref
                                .read(autentikasiProvider.notifier)
                                .gantiPeranDemo('admin');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Beralih ke Peran Administrator')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: pengguna?.isAdmin == true ? WarnaAplikasi.utama : Colors.white,
                            foregroundColor: pengguna?.isAdmin == true ? Colors.white : WarnaAplikasi.utama,
                          ),
                          child: const Text('Jadikan Admin'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ref
                                .read(autentikasiProvider.notifier)
                                .gantiPeranDemo('pelanggan');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Beralih ke Peran Pelanggan')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: pengguna?.isAdmin != true ? WarnaAplikasi.utama : Colors.white,
                            foregroundColor: pengguna?.isAdmin != true ? Colors.white : WarnaAplikasi.utama,
                          ),
                          child: const Text('Jadikan Pelanggan'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Informasi Sistem Backend Mikroservis
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: WarnaAplikasi.garisBatas),
              ),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.dns_outlined, color: WarnaAplikasi.utama),
                    title: Text('Arsitektur Backend'),
                    subtitle: Text('PHP 8.3 Native Microservices (6 Layanan)'),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.storage_outlined, color: WarnaAplikasi.utama),
                    title: Text('Database & ORM'),
                    subtitle: Text('MySQL + Standalone Eloquent ORM'),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.security, color: WarnaAplikasi.utama),
                    title: Text('Keamanan Autentikasi'),
                    subtitle: Text('Stateless JWT (HMAC-SHA256) + CORS Guard'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: WarnaAplikasi.utama),
                    title: const Text('Versi Aplikasi'),
                    subtitle: const Text('Webee Florist v1.0.0 Enterprise'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Siap Pakai',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Tombol Keluar Sesi
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(autentikasiProvider.notifier).keluar();
                },
                icon: const Icon(Icons.logout, color: WarnaAplikasi.bahaya),
                label: const Text(
                  'Keluar dari Sesi Akun',
                  style: TextStyle(color: WarnaAplikasi.bahaya, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: WarnaAplikasi.bahaya),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
