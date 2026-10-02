import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../inti/konstanta/konstanta_api.dart';
import '../../../../inti/konstanta/warna_aplikasi.dart';

class DialogPratinjauFotoZoom extends StatefulWidget {
  final List<String> daftarFoto;
  final int indeksAwal;
  final String? judul;

  const DialogPratinjauFotoZoom({
    super.key,
    required this.daftarFoto,
    this.indeksAwal = 0,
    this.judul,
  });

  static Future<void> tampilkan(
    BuildContext context, {
    required List<String> daftarFoto,
    int indeksAwal = 0,
    String? judul,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      barrierDismissible: true,
      builder: (_) => DialogPratinjauFotoZoom(
        daftarFoto: daftarFoto,
        indeksAwal: indeksAwal,
        judul: judul,
      ),
    );
  }

  @override
  State<DialogPratinjauFotoZoom> createState() => _DialogPratinjauFotoZoomState();
}

class _DialogPratinjauFotoZoomState extends State<DialogPratinjauFotoZoom> {
  late final PageController _pageController;
  late int _indeksAktif;
  final TransformationController _transformController = TransformationController();

  @override
  void initState() {
    super.initState();
    _indeksAktif = widget.indeksAwal.clamp(0, widget.daftarFoto.isEmpty ? 0 : widget.daftarFoto.length - 1);
    _pageController = PageController(initialPage: _indeksAktif);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.daftarFoto.where((f) => f.trim().isNotEmpty).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Area Foto dengan InteractiveViewer & PageView
          Center(
            child: list.isEmpty
                ? const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 64)
                : PageView.builder(
                    controller: _pageController,
                    itemCount: list.length,
                    onPageChanged: (idx) {
                      _resetZoom();
                      setState(() => _indeksAktif = idx);
                    },
                    itemBuilder: (context, idx) {
                      final url = KonstantaApi.formatUrlGambar(list[idx]);
                      return InteractiveViewer(
                        transformationController: _transformController,
                        minScale: 0.8,
                        maxScale: 4.5,
                        clipBehavior: Clip.none,
                        child: Center(
                          child: Image.network(
                            url,
                            fit: BoxFit.contain,
                            loadingBuilder: (_, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: WarnaAplikasi.emasKlasik,
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.broken_image_outlined, color: Colors.white54, size: 64),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Header Bar Transparan Atas
          Positioned(
            top: 24,
            left: 20,
            right: 20,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Judul & Indikator Halaman
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.judul != null && widget.judul!.isNotEmpty)
                          Text(
                            widget.judul!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          list.length > 1
                              ? 'Foto ${_indeksAktif + 1} dari ${list.length} • Cubit / Tarik untuk Memperbesar (Zoom)'
                              : 'Cubit / Tarik untuk Memperbesar (Zoom)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tombol Tutup
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                      tooltip: 'Tutup Pratinjau',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tombol Panah Geser Kiri (Desktop / Web)
          if (list.length > 1 && _indeksAktif > 0)
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black45,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                  ),
                  icon: const Icon(Icons.chevron_left_rounded, size: 32),
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),

          // Tombol Panah Geser Kanan (Desktop / Web)
          if (list.length > 1 && _indeksAktif < list.length - 1)
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black45,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                  ),
                  icon: const Icon(Icons.chevron_right_rounded, size: 32),
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),

          // Titik Indikator Bawah
          if (list.length > 1)
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(list.length, (i) {
                    final adalahAktif = i == _indeksAktif;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: adalahAktif ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: adalahAktif ? WarnaAplikasi.emasKlasik : Colors.white38,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
