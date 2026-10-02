import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../inti/konstanta/konstanta_api.dart';
import '../../../../inti/konstanta/warna_aplikasi.dart';
import '../../../katalog_bunga/data/model/produk_model.dart';
import '../../../katalog_bunga/presentasi/penyedia/penyedia_katalog.dart';

class DialogInputProdukBunga extends ConsumerStatefulWidget {
  final ProdukBungaModel? produk;

  const DialogInputProdukBunga({
    super.key,
    this.produk,
  });

  @override
  ConsumerState<DialogInputProdukBunga> createState() => _DialogInputProdukBungaState();
}

class _DialogInputProdukBungaState extends ConsumerState<DialogInputProdukBunga> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _namaController;
  late final TextEditingController _hargaController;
  late final TextEditingController _stokController;
  late final TextEditingController _urlGambarController;
  late final TextEditingController _deskripsiController;

  late int _kategoriId;
  late bool _apakahUnggulan;
  late bool _apakahTersedia;
  bool _sedangMenyimpan = false;
  bool _sedangUnggahFoto = false;

  final List<String> _daftarFoto = [];

  @override
  void initState() {
    super.initState();
    final p = widget.produk;
    _namaController = TextEditingController(text: p?.nama ?? '');
    _hargaController = TextEditingController(text: p != null ? p.harga.toInt().toString() : '');
    _stokController = TextEditingController(text: p != null ? p.stok.toString() : '10');
    _urlGambarController = TextEditingController(text: p?.urlGambar ?? '');
    _deskripsiController = TextEditingController(text: p?.deskripsi ?? '');

    _kategoriId = p?.kategoriId ?? 2;
    _apakahUnggulan = p?.apakahUnggulan ?? false;
    _apakahTersedia = p?.apakahTersedia ?? true;

    if (p != null) {
      _daftarFoto.addAll(p.semuaFoto);
    }

    _urlGambarController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    _urlGambarController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _pilihDanUnggahFotoPerangkat() async {
    try {
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage(
        imageQuality: 85,
      );

      if (pickedFiles.isEmpty) return;

      setState(() => _sedangUnggahFoto = true);

      final hasilUpload = await ref.read(aksiKatalogAdminProvider.notifier).unggahBanyakFoto(pickedFiles);

      if (hasilUpload != null && hasilUpload.isNotEmpty) {
        setState(() {
          for (final url in hasilUpload) {
            if (!_daftarFoto.contains(url)) {
              _daftarFoto.add(url);
            }
          }
          if (_urlGambarController.text.trim().isEmpty && _daftarFoto.isNotEmpty) {
            _urlGambarController.text = _daftarFoto.first;
          }
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${hasilUpload.length} foto rangkaian berhasil diunggah ke server.',
                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              backgroundColor: WarnaAplikasi.coklatMawar,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: WarnaAplikasi.emasKlasik, width: 0.8),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal memilih atau mengunggah foto: $e',
              style: GoogleFonts.plusJakartaSans(color: Colors.white),
            ),
            backgroundColor: Colors.red.shade800,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sedangUnggahFoto = false);
    }
  }

  void _tambahUrlManual() {
    final url = _urlGambarController.text.trim();
    if (url.isNotEmpty && !_daftarFoto.contains(url)) {
      setState(() {
        _daftarFoto.add(url);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tautan foto ditambahkan ke galeri rangkaian.',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: WarnaAplikasi.coklatMawar,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _hapusFoto(int index) {
    setState(() {
      final dihapus = _daftarFoto.removeAt(index);
      if (_urlGambarController.text.trim() == dihapus) {
        _urlGambarController.text = _daftarFoto.isNotEmpty ? _daftarFoto.first : '';
      }
    });
  }

  void _jadikanFotoUtama(String url) {
    setState(() {
      _urlGambarController.text = url;
      // Pindahkan ke posisi terdepan
      _daftarFoto.remove(url);
      _daftarFoto.insert(0, url);
    });
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final fotoUtama = _urlGambarController.text.trim().isNotEmpty
        ? _urlGambarController.text.trim()
        : (_daftarFoto.isNotEmpty ? _daftarFoto.first : '');

    if (fotoUtama.isEmpty && _daftarFoto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Harap unggah minimal satu foto atau masukkan URL foto rangkaian bunga.',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _sedangMenyimpan = true);

    final payload = {
      'id_kategori': _kategoriId,
      'nama_bunga': _namaController.text.trim(),
      'harga': double.tryParse(_hargaController.text.trim()) ?? 0,
      'stok': int.tryParse(_stokController.text.trim()) ?? 0,
      'deskripsi': _deskripsiController.text.trim(),
      'gambar_url': fotoUtama,
      'foto_galeri': _daftarFoto.isNotEmpty ? _daftarFoto : [fotoUtama],
      'apakah_unggulan': _apakahUnggulan,
      'status_tersedia': _apakahTersedia,
    };

    final notifier = ref.read(aksiKatalogAdminProvider.notifier);
    bool sukses = false;

    if (widget.produk == null) {
      sukses = await notifier.tambahProduk(payload);
    } else {
      sukses = await notifier.perbaruiProduk(widget.produk!.id, payload);
    }

    if (!mounted) return;
    setState(() => _sedangMenyimpan = false);

    if (sukses) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.produk == null
                ? 'Rangkaian bunga baru berhasil ditambahkan ke katalog.'
                : 'Karya rangkaian bunga berhasil diperbarui.',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: WarnaAplikasi.coklatMawar,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: WarnaAplikasi.emasKlasik, width: 1),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyimpan data produk. Silakan coba kembali.',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final adalahEdit = widget.produk != null;
    final kategoriAsync = ref.watch(daftarKategoriProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 780, maxHeight: 880),
        decoration: BoxDecoration(
          color: WarnaAplikasi.putihHangat,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: WarnaAplikasi.coklatMawar.withValues(alpha: 0.16),
              blurRadius: 36,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header Dialog Romantis
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              decoration: BoxDecoration(
                color: WarnaAplikasi.kremLatar,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
                border: Border(
                  bottom: BorderSide(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.3)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: WarnaAplikasi.coklatMawar.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.4)),
                    ),
                    child: Icon(
                      adalahEdit ? Icons.edit_note_rounded : Icons.local_florist_rounded,
                      color: WarnaAplikasi.coklatMawar,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          adalahEdit ? 'Perbarui Rangkaian Bunga' : 'Tambah Rangkaian Bunga Baru',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: WarnaAplikasi.coklatMawar,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Koleksi Elegan Atelier Webee Florist • Mendukung Galeri Multi-Foto',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: WarnaAplikasi.abuTua,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: WarnaAplikasi.coklatMawar,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Bunga & Kategori
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buatLabel('Nama Rangkaian Bunga *'),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _namaController,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: WarnaAplikasi.hitamMewah,
                                  ),
                                  decoration: _dekorasiInput(
                                    petunjuk: 'Contoh: Royal Scarlet Velvet Bouquet',
                                    ikon: Icons.local_florist_outlined,
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Nama rangkaian wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buatLabel('Kategori Bunga *'),
                                const SizedBox(height: 6),
                                kategoriAsync.when(
                                  data: (kategoriList) {
                                    final opsiKategori = kategoriList.where((k) => k.slug != 'semua' && k.id > 0).toList();
                                    return DropdownButtonFormField<int>(
                                      isExpanded: true,
                                      value: opsiKategori.any((k) => k.id == _kategoriId)
                                          ? _kategoriId
                                          : (opsiKategori.isNotEmpty ? opsiKategori.first.id : 1),
                                      decoration: _dekorasiInput(
                                        petunjuk: 'Pilih Kategori',
                                        ikon: Icons.category_outlined,
                                      ),
                                      items: opsiKategori.map((k) {
                                        return DropdownMenuItem<int>(
                                          value: k.id,
                                          child: Text(
                                            k.nama,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() => _kategoriId = val);
                                        }
                                      },
                                    );
                                  },
                                  loading: () => const SizedBox(
                                    height: 48,
                                    child: Center(
                                      child: SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                  ),
                                  error: (_, __) => Text(
                                    'Gagal memuat kategori',
                                    style: GoogleFonts.plusJakartaSans(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Harga & Stok Unit
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buatLabel('Harga Rangkaian (Rp) *'),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _hargaController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: WarnaAplikasi.coklatMawar,
                                  ),
                                  decoration: _dekorasiInput(
                                    petunjuk: 'Contoh: 450000',
                                    awalan: 'Rp ',
                                    ikon: Icons.payments_outlined,
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Harga wajib diisi';
                                    }
                                    final n = double.tryParse(v);
                                    if (n == null || n <= 0) {
                                      return 'Harga harus lebih dari 0';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buatLabel('Stok Tersedia (Unit) *'),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _stokController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: WarnaAplikasi.hitamMewah,
                                  ),
                                  decoration: _dekorasiInput(
                                    petunjuk: 'Contoh: 15',
                                    ikon: Icons.inventory_2_outlined,
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Stok wajib diisi';
                                    }
                                    final n = int.tryParse(v);
                                    if (n == null || n < 0) {
                                      return 'Stok tidak valid';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Seksi Unggah Foto dari Perangkat Lokal (Multi-Gambar)
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: WarnaAplikasi.kremLatar.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.35)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.photo_library_outlined,
                                        color: WarnaAplikasi.coklatMawar,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Galeri Foto Rangkaian Bunga (Bisa Banyak Foto)',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: WarnaAplikasi.coklatMawar,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Tombol Pilih Foto dari Perangkat
                                ElevatedButton.icon(
                                  onPressed: _sedangUnggahFoto ? null : _pilihDanUnggahFotoPerangkat,
                                  icon: _sedangUnggahFoto
                                      ? const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.file_upload_outlined, size: 16),
                                  label: Text(
                                    _sedangUnggahFoto
                                        ? 'Mengunggah...'
                                        : 'Unggah dari Perangkat',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: WarnaAplikasi.coklatMawar,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(color: WarnaAplikasi.emasKlasik, width: 0.6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Pilih satu atau beberapa foto dari galeri komputer/ponsel. Foto diunggah langsung ke penyimpanan server backend dan dapat digeser-geser oleh pelanggan.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: WarnaAplikasi.abuTua,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Pratinjau Daftar Foto Galeri
                            if (_daftarFoto.isNotEmpty) ...[
                              SizedBox(
                                height: 110,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _daftarFoto.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                                  itemBuilder: (context, idx) {
                                    final fotoUrl = _daftarFoto[idx];
                                    final fullUrl = KonstantaApi.formatUrlGambar(fotoUrl);
                                    final adalahSampul = fotoUrl == _urlGambarController.text.trim() ||
                                        (idx == 0 && _urlGambarController.text.trim().isEmpty);

                                    return Container(
                                      width: 110,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: adalahSampul
                                              ? WarnaAplikasi.emasKlasik
                                              : WarnaAplikasi.garisBatas,
                                          width: adalahSampul ? 2 : 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.06),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          // Gambar Thumbnail
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(9),
                                            child: Image.network(
                                              fullUrl,
                                              width: 110,
                                              height: 110,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => const Center(
                                                child: Icon(
                                                  Icons.broken_image_outlined,
                                                  size: 24,
                                                  color: WarnaAplikasi.abuTua,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Badge Sampul Utama
                                          if (adalahSampul)
                                            Positioned(
                                              top: 4,
                                              left: 4,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: WarnaAplikasi.coklatMawar,
                                                  borderRadius: BorderRadius.circular(4),
                                                  border: Border.all(
                                                    color: WarnaAplikasi.emasKlasik,
                                                    width: 0.6,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Sampul',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),

                                          // Tombol Hapus Foto
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: InkWell(
                                              onTap: () => _hapusFoto(idx),
                                              child: Container(
                                                padding: const EdgeInsets.all(3),
                                                decoration: const BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close_rounded,
                                                  size: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Tombol Jadikan Sampul (jika bukan sampul)
                                          if (!adalahSampul)
                                            Positioned(
                                              bottom: 4,
                                              left: 4,
                                              right: 4,
                                              child: InkWell(
                                                onTap: () => _jadikanFotoUtama(fotoUrl),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withValues(alpha: 0.9),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Jadikan Sampul',
                                                      style: GoogleFonts.plusJakartaSans(
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.w700,
                                                        color: WarnaAplikasi.coklatMawar,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Input URL Eksternal Cadangan
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _urlGambarController,
                                    style: GoogleFonts.plusJakartaSans(fontSize: 12),
                                    decoration: InputDecoration(
                                      hintText: 'Atau masukkan tautan gambar web (URL CDN / Unsplash)...',
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: WarnaAplikasi.abuTua.withValues(alpha: 0.6),
                                      ),
                                      prefixIcon: const Icon(Icons.link_rounded, size: 18, color: WarnaAplikasi.emasKlasik),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.3)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.3)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                OutlinedButton(
                                  onPressed: _tambahUrlManual,
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    side: BorderSide(color: WarnaAplikasi.coklatMawar.withValues(alpha: 0.5)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text(
                                    '+ Ke Galeri',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: WarnaAplikasi.coklatMawar,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Deskripsi & Filosofi
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buatLabel('Deskripsi & Filosofi Bunga'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _deskripsiController,
                            maxLines: 3,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.4),
                            decoration: _dekorasiInput(
                              petunjuk: 'Tuliskan komposisi kuntum bunga, warna pita, dan pesan keanggunan...',
                              ikon: Icons.auto_stories_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Dua Pengaturan Sakelar (Unggulan & Ketersediaan)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: WarnaAplikasi.kremLatar.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.25)),
                        ),
                        child: Column(
                          children: [
                            SwitchListTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              activeColor: WarnaAplikasi.coklatMawar,
                              activeTrackColor: WarnaAplikasi.emasKlasik.withValues(alpha: 0.5),
                              value: _apakahUnggulan,
                              title: Text(
                                'Koleksi Unggulan (Atelier Signature)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: WarnaAplikasi.coklatMawar,
                                ),
                              ),
                              subtitle: Text(
                                'Tampilkan di barisan etalase utama beranda depan pengunjung.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: WarnaAplikasi.abuTua,
                                ),
                              ),
                              onChanged: (val) {
                                setState(() => _apakahUnggulan = val);
                              },
                            ),
                            Divider(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.2)),
                            SwitchListTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              activeColor: WarnaAplikasi.hijauStatus,
                              value: _apakahTersedia,
                              title: Text(
                                'Status Ketersediaan Bunga',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: WarnaAplikasi.coklatMawar,
                                ),
                              ),
                              subtitle: Text(
                                _apakahTersedia
                                    ? 'Kuntum bunga segar siap dirangkai dan dipesan.'
                                    : 'Kuntum bunga habis musiman / sedang tidak dapat dipesan.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: _apakahTersedia ? WarnaAplikasi.hijauStatus : Colors.red.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onChanged: (val) {
                                setState(() => _apakahTersedia = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer Tombol Aksi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              decoration: BoxDecoration(
                color: WarnaAplikasi.kremLatar,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                border: Border(
                  top: BorderSide(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.3)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _sedangMenyimpan ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: WarnaAplikasi.coklatMawar.withValues(alpha: 0.4)),
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Batal',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: WarnaAplikasi.coklatMawar,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  ElevatedButton(
                    onPressed: _sedangMenyimpan ? null : _simpan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WarnaAplikasi.coklatMawar,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: WarnaAplikasi.emasKlasik, width: 0.8),
                      ),
                    ),
                    child: _sedangMenyimpan
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            adalahEdit ? 'Simpan Perubahan' : 'Tambah ke Koleksi',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.4,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buatLabel(String teks) {
    return Text(
      teks,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: WarnaAplikasi.coklatMawar,
        letterSpacing: 0.2,
      ),
    );
  }

  InputDecoration _dekorasiInput({
    required String petunjuk,
    required IconData ikon,
    String? awalan,
  }) {
    return InputDecoration(
      hintText: petunjuk,
      hintStyle: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        color: WarnaAplikasi.abuTua.withValues(alpha: 0.6),
      ),
      prefixText: awalan,
      prefixStyle: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: WarnaAplikasi.coklatMawar,
      ),
      prefixIcon: Icon(ikon, size: 20, color: WarnaAplikasi.emasKlasik),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.35)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: WarnaAplikasi.coklatMawar, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
      ),
    );
  }
}
