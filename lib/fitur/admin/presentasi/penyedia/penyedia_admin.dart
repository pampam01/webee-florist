import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/admin/data/model/ringkasan_admin_model.dart';
import 'package:webee_florist/fitur/admin/data/repositori/repositori_admin.dart';
import 'package:webee_florist/inti/jaringan/hasil_api.dart';

final repositoriAdminProvider = Provider<RepositoriAdmin>((ref) {
  return RepositoriAdmin();
});

final ringkasanAdminProvider = FutureProvider<RingkasanAdminModel>((ref) async {
  final repo = ref.watch(repositoriAdminProvider);
  final hasil = await repo.ambilRingkasan();
  if (hasil is ApiSukses<RingkasanAdminModel>) {
    return hasil.data;
  }
  return const RingkasanAdminModel(
    totalOmset: 0,
    totalPesanan: 0,
    pesananDiproses: 0,
    pesananMenungguBayar: 0,
    totalPelanggan: 0,
    totalProdukAktif: 0,
  );
});
