import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/keranjang/presentasi/penyedia/penyedia_keranjang.dart';
import 'package:webee_florist/fitur/pesanan/presentasi/penyedia/penyedia_pesanan.dart';
import 'package:webee_florist/inti/konstanta/warna_aplikasi.dart';
import 'package:webee_florist/inti/utilitas/format_rupiah.dart';

class HalamanCheckout extends ConsumerStatefulWidget {
  const HalamanCheckout({super.key});

  @override
  ConsumerState<HalamanCheckout> createState() => _HalamanCheckoutState();
}

class _HalamanCheckoutState extends ConsumerState<HalamanCheckout> {
  final _kunciForm = GlobalKey<FormState>();
  final _penerimaKontroller = TextEditingController(text: 'Clara Anindya');
  final _teleponKontroller = TextEditingController(text: '081298765432');
  final _alamatKontroller = TextEditingController(
      text: 'Jl. Senopati No. 45, Kebayoran Baru, Jakarta Selatan');
  final _ucapanKontroller = TextEditingController(
      text: 'Selamat ulang tahun yang terindah, Clara tercinta! Semoga senantiasa bahagia.');
  final _tanggalKontroller = TextEditingController(text: '2026-10-02');
  String _metodePembayaran = 'QRIS';

  final double _biayaKirim = 20000;

  @override
  void dispose() {
    _penerimaKontroller.dispose();
    _teleponKontroller.dispose();
    _alamatKontroller.dispose();
    _ucapanKontroller.dispose();
    _tanggalKontroller.dispose();
    super.dispose();
  }

  Future<void> _prosesCheckout() async {
    if (!_kunciForm.currentState!.validate()) return;

    final sukses = await ref.read(buatPesananProvider.notifier).kirimPesanan(
          namaPenerima: _penerimaKontroller.text.trim(),
          teleponPenerima: _teleponKontroller.text.trim(),
          alamatPengiriman: _alamatKontroller.text.trim(),
          pesanKartuUcapan: _ucapanKontroller.text.trim(),
          tanggalKirim: _tanggalKontroller.text.trim(),
          metodePembayaran: _metodePembayaran,
        );

    if (!mounted) return;

    if (sukses) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: WarnaAplikasi.sukses, size: 64),
          title: const Text('Pesanan Bunga Berhasil!'),
          content: const Text(
            'Buket bunga pilihan Anda sedang disiapkan oleh florist profesional kami dengan penuh cinta.',
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Lihat Riwayat Pesanan'),
            ),
          ],
        ),
      );
    } else {
      final pesan = ref.read(buatPesananProvider).pesanKesalahan ?? 'Gagal memproses';
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
    final stateKeranjang = ref.watch(keranjangProvider);
    final stateCheckout = ref.watch(buatPesananProvider);
    final grandTotal = stateKeranjang.totalHarga + _biayaKirim;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout & Pengiriman'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _kunciForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informasi Penerima Bunga',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: WarnaAplikasi.utama,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _penerimaKontroller,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap Penerima',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _teleponKontroller,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor WhatsApp Penerima',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _alamatKontroller,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Alamat Pengantaran Lengkap',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 24),

              const Text(
                'Kartu Ucapan Personal (Komplementer)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: WarnaAplikasi.utama,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tuliskan pesan yang akan dicetak di kartu eksklusif berpita Webee Florist.',
                style: TextStyle(fontSize: 12, color: WarnaAplikasi.teksSekunder),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ucapanKontroller,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Isi Pesan Kartu Ucapan',
                  hintText: 'Contoh: Selamat atas wisudanya, kami sangat bangga padamu!',
                  prefixIcon: Icon(Icons.favorite_border),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tanggalKontroller,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Pengantaran (YYYY-MM-DD)',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: WarnaAplikasi.utama,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: WarnaAplikasi.garisBatas),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('QRIS Instan (GoPay, OVO, Dana, BCA)'),
                      subtitle: const Text('Scan & verifikasi langsung otomatis'),
                      value: 'QRIS',
                      groupValue: _metodePembayaran,
                      activeColor: WarnaAplikasi.utama,
                      onChanged: (val) => setState(() => _metodePembayaran = val!),
                    ),
                    const Divider(height: 1),
                    RadioListTile<String>(
                      title: const Text('Transfer Bank BCA'),
                      subtitle: const Text('No. Rek: 8820-9918-22 (Webee Florist)'),
                      value: 'Transfer BCA',
                      groupValue: _metodePembayaran,
                      activeColor: WarnaAplikasi.utama,
                      onChanged: (val) => setState(() => _metodePembayaran = val!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: WarnaAplikasi.garisBatas),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Bunga:'),
                        Text(
                          FormatRupiah.format(stateKeranjang.totalHarga),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ongkos Kirim Kurir Florist:'),
                        Text(
                          FormatRupiah.format(_biayaKirim),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Pembayaran:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          FormatRupiah.format(grandTotal),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                            color: WarnaAplikasi.utama,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: stateCheckout.sedangMemuat ? null : _prosesCheckout,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: stateCheckout.sedangMemuat
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Bayar ${FormatRupiah.format(grandTotal)} Sekarang',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
