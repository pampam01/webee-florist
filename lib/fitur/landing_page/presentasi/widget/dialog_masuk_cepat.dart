import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/autentikasi/presentasi/halaman/halaman_daftar.dart';
import 'package:webee_florist/fitur/autentikasi/presentasi/penyedia/penyedia_autentikasi.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';

class DialogMasukCepat extends ConsumerStatefulWidget {
  final VoidCallback? padaBerhasilMasuk;

  const DialogMasukCepat({super.key, this.padaBerhasilMasuk});

  static Future<void> tampilkan(BuildContext context, {VoidCallback? padaBerhasilMasuk}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => DialogMasukCepat(padaBerhasilMasuk: padaBerhasilMasuk),
    );
  }

  @override
  ConsumerState<DialogMasukCepat> createState() => _DialogMasukCepatState();
}

class _DialogMasukCepatState extends ConsumerState<DialogMasukCepat> {
  final _kunciForm = GlobalKey<FormState>();
  final _emailKontroller = TextEditingController(text: 'budi@gmail.com');
  final _kataSandiKontroller = TextEditingController(text: 'pelanggan123');
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
      Navigator.of(context).pop();
      widget.padaBerhasilMasuk?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil masuk ke akun Webee Florist.'),
          backgroundColor: WarnaAplikasi.sukses,
        ),
      );
    } else {
      final pesan = ref.read(autentikasiProvider).pesanKesalahan ?? 'Gagal masuk.';
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

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _kunciForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Dialog
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Masuk ke Akun Anda',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: WarnaAplikasi.utama,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Lanjutkan pemesanan buket bunga pilihan Anda',
                          style: TextStyle(
                            fontSize: 13,
                            color: WarnaAplikasi.teksSekunder,
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
                const SizedBox(height: 24),

                // Form Email
                TextFormField(
                  controller: _emailKontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Email',
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Email wajib diisi';
                    if (!val.contains('@')) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Form Kata Sandi
                TextFormField(
                  controller: _kataSandiKontroller,
                  obscureText: _sembunyikanSandi,
                  decoration: InputDecoration(
                    labelText: 'Kata Sandi',
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _sembunyikanSandi ? Icons.visibility_off : Icons.visibility,
                        size: 20,
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
                const SizedBox(height: 20),

                // Tombol Masuk
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
                          'Masuk & Lanjut ke Checkout',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 20),

                // Uji Coba Cepat (Akun Demo)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: WarnaAplikasi.latarBelakang,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: WarnaAplikasi.garisBatas),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Akses Demo Cepat:',
                        style: TextStyle(
                          fontSize: 11,
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
                                'budi@gmail.com',
                                'pelanggan123',
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: const Text('Akun Pelanggan', style: TextStyle(fontSize: 11)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _pilihAkunCepat(
                                'admin@webee-florist.com',
                                'admin123',
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: const Text('Akun Admin', style: TextStyle(fontSize: 11)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Navigasi ke Daftar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum memiliki akun? ',
                      style: TextStyle(fontSize: 13, color: WarnaAplikasi.teksSekunder),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const HalamanDaftar()),
                        );
                      },
                      child: const Text(
                        'Daftar Baru',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: WarnaAplikasi.utama,
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
    );
  }
}
