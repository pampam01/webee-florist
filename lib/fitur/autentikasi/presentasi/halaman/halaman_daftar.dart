import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/autentikasi/presentasi/penyedia/penyedia_autentikasi.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class HalamanDaftar extends ConsumerStatefulWidget {
  const HalamanDaftar({super.key});

  @override
  ConsumerState<HalamanDaftar> createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends ConsumerState<HalamanDaftar> {
  final _kunciForm = GlobalKey<FormState>();
  final _namaKontroller = TextEditingController();
  final _emailKontroller = TextEditingController();
  final _kataSandiKontroller = TextEditingController();
  final _teleponKontroller = TextEditingController();
  final _alamatKontroller = TextEditingController();
  bool _sembunyikanSandi = true;

  @override
  void dispose() {
    _namaKontroller.dispose();
    _emailKontroller.dispose();
    _kataSandiKontroller.dispose();
    _teleponKontroller.dispose();
    _alamatKontroller.dispose();
    super.dispose();
  }

  Future<void> _kirimDaftar() async {
    if (!_kunciForm.currentState!.validate()) return;

    final sukses = await ref.read(autentikasiProvider.notifier).daftar(
          nama: _namaKontroller.text.trim(),
          email: _emailKontroller.text.trim(),
          kataSandi: _kataSandiKontroller.text,
          noTelepon: _teleponKontroller.text.trim(),
          alamat: _alamatKontroller.text.trim(),
        );

    if (!mounted) return;

    if (sukses) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Akun berhasil dibuat. Selamat berbelanja.'),
          backgroundColor: WarnaAplikasi.sukses,
        ),
      );
    } else {
      final pesan = ref.read(autentikasiProvider).pesanKesalahan ?? 'Pendaftaran gagal';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(pesan),
          backgroundColor: WarnaAplikasi.bahaya,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateAuth = ref.watch(autentikasiProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Akun Pelanggan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _kunciForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Bergabung dengan Webee Florist',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: WarnaAplikasi.utama,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Dapatkan penawaran bunga terbaik dan pengiriman tepat waktu.',
                  style: TextStyle(color: WarnaAplikasi.teksSekunder),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _namaKontroller,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailKontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Email',
                    prefixIcon: Icon(Icons.email_outlined),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _teleponKontroller,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Nomor WhatsApp / HP',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _alamatKontroller,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Pengiriman Lengkap',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: stateAuth.sedangMemuat ? null : _kirimDaftar,
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
                          'Daftar Sekarang',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
