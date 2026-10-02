import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/admin/presentasi/halaman/halaman_dashboard_admin.dart';
import 'package:webee_florist/fitur/admin/presentasi/widget/badge_urgensi_pengantaran.dart';
import 'package:webee_florist/fitur/admin/presentasi/widget/dialog_kartu_ucapan_admin.dart';
import 'package:webee_florist/fitur/pesanan/data/model/pesanan_model.dart';
import 'package:webee_florist/fitur/pesanan/data/repositori/repositori_pesanan.dart';
import 'package:webee_florist/inti/jaringan/hasil_api.dart';

void main() {
  group('Admin Bagian 1 - Model & Logistik Kurir', () {
    test('PesananModel parses logistics fields correctly from JSON', () {
      final json = {
        'id': 99,
        'nomor_pesanan': 'WBF-TEST-001',
        'pengguna_id': 10,
        'total_harga': '550000.00',
        'biaya_kirim': '30000.00',
        'grand_total': '580000.00',
        'status': 'dikirim',
        'nama_penerima': 'Princess Charlotte',
        'telepon_penerima': '081234567890',
        'alamat_pengiriman': 'Jl. Senopati No. 1, Jakarta',
        'kartu_ucapan': 'Joyeux Anniversaire mon cherie!',
        'tanggal_pengiriman': '2026-10-02',
        'jenis_kurir': 'armada_mobil_berpendingin',
        'nama_kurir': 'Ahmad Fauzi',
        'telepon_kurir': '081299887766',
        'nomor_resi': 'WBF-CHILLED-01',
        'estimasi_jam_kirim': '14:00 - 16:00',
        'item': [
          {
            'id': 1,
            'id_produk': 5,
            'nama_produk': 'Buket Mawar Provence',
            'harga_satuan': 550000.0,
            'kuantitas': 1,
            'subtotal': 550000.0,
          }
        ]
      };

      final model = PesananModel.fromJson(json);

      expect(model.id, 99);
      expect(model.nomorPesanan, 'WBF-TEST-001');
      expect(model.status, 'dikirim');
      expect(model.jenisKurir, 'armada_mobil_berpendingin');
      expect(model.namaKurir, 'Ahmad Fauzi');
      expect(model.teleponKurir, '081299887766');
      expect(model.nomorResi, 'WBF-CHILLED-01');
      expect(model.estimasiJamKirim, '14:00 - 16:00');
      expect(model.pesanKartuUcapan, 'Joyeux Anniversaire mon cherie!');
      expect(model.tanggalKirim, '2026-10-02');
      expect(model.itemPesanan.length, 1);
      expect(model.itemPesanan.first.namaProdukSnapshot, 'Buket Mawar Provence');
    });

    test('RepositoriPesanan ambilSemuaPesananAdmin filters properly in fallback mode', () async {
      final repo = RepositoriPesanan();
      final hasilSemua = await repo.ambilSemuaPesananAdmin();
      expect(hasilSemua, isA<ApiSukses<List<PesananModel>>>());
      final daftarSemua = (hasilSemua as ApiSukses<List<PesananModel>>).data;
      expect(daftarSemua.isNotEmpty, isTrue);

      final hasilFilterDiproses = await repo.ambilSemuaPesananAdmin(status: 'diproses');
      final daftarDiproses = (hasilFilterDiproses as ApiSukses<List<PesananModel>>).data;
      for (final p in daftarDiproses) {
        expect(p.status, 'diproses');
      }

      final hasilCari = await repo.ambilSemuaPesananAdmin(cari: 'Lady Genevieve');
      final daftarCari = (hasilCari as ApiSukses<List<PesananModel>>).data;
      expect(daftarCari.any((p) => p.namaPenerima.contains('Genevieve')), isTrue);
    });
  });

  group('Admin Bagian 1 - Widget Tests', () {
    testWidgets('BadgeUrgensiPengantaran displays HARI INI for today delivery', (tester) async {
      final sekarang = DateTime.now();
      final hariIniStr = '${sekarang.year}-${sekarang.month.toString().padLeft(2, '0')}-${sekarang.day.toString().padLeft(2, '0')}';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BadgeUrgensiPengantaran(
              tanggalKirim: hariIniStr,
              estimasiJam: '14:00',
            ),
          ),
        ),
      );

      expect(find.textContaining('PENGANTARAN HARI INI'), findsOneWidget);
      expect(find.textContaining('(14:00)'), findsOneWidget);
    });

    testWidgets('DialogKartuUcapanAdmin renders calligraphy preview and buttons', (tester) async {
      const pesanan = PesananModel(
        id: 10,
        nomorPesanan: 'WBF-CARD-001',
        penggunaId: 1,
        totalHarga: 450000,
        biayaKirim: 20000,
        grandTotal: 470000,
        status: 'diproses',
        namaPenerima: 'Lady Genevieve',
        teleponPenerima: '081234567890',
        alamatPengiriman: 'Jl. Senopati No. 45, Jakarta Selatan',
        pesanKartuUcapan: 'Semoga hari bahagiamu seharum mawar Provence.',
        tanggalKirim: '2026-10-02',
        jenisKurir: 'armada_mobil_berpendingin',
        namaKurir: 'Budi Santoso',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DialogKartuUcapanAdmin(pesanan: pesanan),
          ),
        ),
      );

      expect(find.textContaining('Pour: Lady Genevieve'), findsOneWidget);
      expect(find.textContaining('Semoga hari bahagiamu seharum mawar Provence.'), findsNWidgets(2));
      expect(find.text('Salin Teks Kartu Ucapan'), findsOneWidget);
      expect(find.text('Salin Format Pesan WhatsApp Kurir'), findsOneWidget);
    });

    testWidgets('HalamanDashboardAdmin renders sidebar tabs and default analytics tab', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HalamanDashboardAdmin(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Memverifikasi item menu sidebar tampil
      expect(find.text('Ringkasan & Analitik'), findsWidgets);
      expect(find.text('Pesanan & Logistik'), findsWidgets);
      expect(find.text('Katalog Produk'), findsWidgets);

      // Memverifikasi Tab Utama Analitik memuat laporan dan grafik
      expect(find.text('Ringkasan Kinerja & Analitik Toko Bunga'), findsOneWidget);
      expect(find.text('Tren Omset 7 Hari Terakhir'), findsOneWidget);
      expect(find.text('Distribusi Koleksi Terlaris'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });
  });
}
