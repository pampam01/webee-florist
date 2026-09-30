import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/autentikasi/presentasi/halaman/halaman_daftar.dart';
import 'package:webee_florist/fitur/autentikasi/presentasi/penyedia/penyedia_autentikasi.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class HalamanMasuk extends ConsumerStatefulWidget {
  const HalamanMasuk({super.key});

  @override
  ConsumerState<HalamanMasuk> createState() => _HalamanMasukState();
}

class _HalamanMasukState extends ConsumerState<HalamanMasuk> {
  final _kunciForm = GlobalKey<FormState>();
  final _emailKontroller = TextEditingController(text: 'admin@webee-florist.com');
  final _kataSandiKontroller = TextEditingController(text: 'admin123');
  bool _sembunyikanSandi = true;

  @override
  void dispose() {
    _emailKontroller.dispose();
    _kataSandiKontroller.dispose();
    super.dispose();
  }

  Future<void> _kirimMasuk() async {
    if (!_kunciForm.currentState!.validate()) return;

    final sukses = await ref.read(autentikasiProvider.notifier).masuk(
          _emailKontroller.text.trim(),
          _kataSandiKontroller.text,
        );

    if (!mounted) return;

    if (sukses) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selamat datang di Webee Florist.'),
          backgroundColor: WarnaAplikasi.sukses,
        ),
      );
    } else {
      final pesan = ref.read(autentikasiProvider).pesanKesalahan ?? 'Gagal masuk';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(pesan),
          backgroundColor: WarnaAplikasi.bahaya,
        ),
      );
    }
  }

  void _pilihAkunCepat(String email, String sandi) {
    setState(() {
      _emailKontroller.text = email;
      _kataSandiKontroller.text = sandi;
    });
  }

  @override
  Widget build(BuildContext context) {
    final stateAuth = ref.watch(autentikasiProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _kunciForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: WarnaAplikasi.gradienUtama,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: WarnaAplikasi.utama.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_florist_rounded,
                      size: 42,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Webee Florist',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: WarnaAplikasi.utama,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Bunga Segar Berkualitas Premium & Eksklusif',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: WarnaAplikasi.teksSekunder,
                    ),
                  ),
                  const SizedBox(height: 36),

                  TextFormField(
                    controller: _emailKontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'nama@domain.com',
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Email wajib diisi';
                      if (!val.contains('@')) return 'Format email tidak valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _kataSandiKontroller,
                    obscureText: _sembunyikanSandi,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _sembunyikanSandi ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _sembunyikanSandi = !_sembunyikanSandi;
                          });
                        },
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.length < 6) {
                        return 'Kata sandi minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: stateAuth.sedangMemuat ? null : _kirimMasuk,
                    child: stateAuth.sedangMemuat
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Masuk Sekarang',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: WarnaAplikasi.garisBatas),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Akses Cepat (Akun Demo):',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: WarnaAplikasi.teksUtama,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _pilihAkunCepat(
                                  'admin@webee-florist.com',
                                  'admin123',
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                child: const Text(
                                  'Akun Admin',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _pilihAkunCepat(
                                  'budi@gmail.com',
                                  'pelanggan123',
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                child: const Text(
                                  'Akun Pelanggan',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum memiliki akun? ',
                        style: TextStyle(color: WarnaAplikasi.teksSekunder),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const HalamanDaftar(),
                            ),
                          );
                        },
                        child: const Text(
                          'Daftar Baru',
                          style: TextStyle(
                            color: WarnaAplikasi.utama,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
