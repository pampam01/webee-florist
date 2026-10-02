import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../inti/konstanta/konstanta_api.dart';
import '../../../../inti/konstanta/warna_aplikasi.dart';

import 'dialog_pratinjau_foto_zoom.dart';

class SliderFotoBunga extends StatefulWidget {
  final List<String> daftarFoto;
  final double tinggi;
  final double? aspectRatio;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final bool tampilkanThumbnailBawah;
  final bool bisaDiKlikZoom;
  final String? judulProduk;

  const SliderFotoBunga({
    super.key,
    required this.daftarFoto,
    this.tinggi = 360,
    this.aspectRatio,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.tampilkanThumbnailBawah = false,
    this.bisaDiKlikZoom = true,
    this.judulProduk,
  });

  @override
  State<SliderFotoBunga> createState() => _SliderFotoBungaState();
}

class _SliderFotoBungaState extends State<SliderFotoBunga> {
  late final PageController _pageController;
  int _indeksAktif = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> get _fotoTervalidasi {
    final list = widget.daftarFoto.where((f) => f.trim().isNotEmpty).toList();
    return list;
  }

  void _pindahKeHalaman(int idx) {
    if (idx >= 0 && idx < _fotoTervalidasi.length) {
      _pageController.animateToPage(
        idx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _bukaModalZoom() {
    if (!widget.bisaDiKlikZoom) return;
    final fotoList = _fotoTervalidasi;
    if (fotoList.isEmpty) return;
    DialogPratinjauFotoZoom.tampilkan(
      context,
      daftarFoto: fotoList,
      indeksAwal: _indeksAktif,
      judul: widget.judulProduk ?? 'Detail Rangkaian Bunga',
    );
  }

  @override
  Widget build(BuildContext context) {
    final fotoList = _fotoTervalidasi;
    final radius = widget.borderRadius ?? BorderRadius.circular(16);

    if (fotoList.isEmpty) {
      Widget wadahKosong = Container(
        height: widget.aspectRatio == null ? widget.tinggi : null,
        decoration: BoxDecoration(
          color: WarnaAplikasi.kremLatar,
          borderRadius: radius,
          border: Border.all(color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.3)),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_florist_rounded, size: 48, color: WarnaAplikasi.aksenMawar),
              SizedBox(height: 8),
              Text(
                'Foto Rangkaian Belum Tersedia',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  color: WarnaAplikasi.teksSekunder,
                ),
              ),
            ],
          ),
        ),
      );

      if (widget.aspectRatio != null) {
        return AspectRatio(
          aspectRatio: widget.aspectRatio!,
          child: wadahKosong,
        );
      }
      return wadahKosong;
    }

    Widget wadahSlider = Container(
      height: widget.aspectRatio == null
          ? (widget.tinggi.isFinite ? widget.tinggi : null)
          : null,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: WarnaAplikasi.coklatMawar.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: [
            // Komponen Geser Foto (PageView) dengan dukungan mouse drag Web & Touch
            ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                },
              ),
              child: PageView.builder(
                controller: _pageController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: fotoList.length,
                onPageChanged: (idx) {
                  setState(() => _indeksAktif = idx);
                },
                itemBuilder: (context, idx) {
                  final rawUrl = fotoList[idx];
                  final fullUrl = KonstantaApi.formatUrlGambar(rawUrl);

                  final widgetGambar = Image.network(
                    fullUrl,
                    fit: widget.fit,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: WarnaAplikasi.kremLatar,
                        child: const Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: WarnaAplikasi.coklatMawar,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: WarnaAplikasi.kremLatar,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 40,
                          color: WarnaAplikasi.teksSekunder,
                        ),
                      ),
                    ),
                  );

                  if (widget.bisaDiKlikZoom) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.zoomIn,
                      child: GestureDetector(
                        onTap: _bukaModalZoom,
                        child: widgetGambar,
                      ),
                    );
                  }
                  return widgetGambar;
                },
              ),
            ),

            // Tombol Perbesar Foto (Zoom Overlay Badge)
            if (widget.bisaDiKlikZoom)
              Positioned(
                top: 12,
                right: 12,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _bukaModalZoom,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.zoom_in_rounded, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Perbesar',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Tombol Panah Geser Kiri (Desktop / Web)
            if (fotoList.length > 1 && _indeksAktif > 0)
              Positioned(
                left: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: InkWell(
                    onTap: () => _pindahKeHalaman(_indeksAktif - 1),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: WarnaAplikasi.coklatMawar,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),

            // Tombol Panah Geser Kanan (Desktop / Web)
            if (fotoList.length > 1 && _indeksAktif < fotoList.length - 1)
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: InkWell(
                    onTap: () => _pindahKeHalaman(_indeksAktif + 1),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: WarnaAplikasi.coklatMawar,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),

            // Indikator Posisi Foto & Titik Slider
            if (fotoList.length > 1)
              Positioned(
                bottom: 14,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: WarnaAplikasi.coklatMawar.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.5),
                          width: 0.6,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Deretan Titik Indikator
                          ...List.generate(fotoList.length, (i) {
                            final adalahAktif = i == _indeksAktif;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: adalahAktif ? 16 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: adalahAktif ? WarnaAplikasi.emasKlasik : Colors.white.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            );
                          }),
                          const SizedBox(width: 8),
                          // Angka Counter Foto
                          Text(
                            '${_indeksAktif + 1}/${fotoList.length}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    if (widget.aspectRatio != null) {
      wadahSlider = AspectRatio(
        aspectRatio: widget.aspectRatio!,
        child: wadahSlider,
      );
    }

    if (!widget.tampilkanThumbnailBawah || fotoList.length <= 1) {
      return wadahSlider;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        wadahSlider,
        if (widget.tampilkanThumbnailBawah && fotoList.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: fotoList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, idx) {
                final terpilih = idx == _indeksAktif;
                final fullThumbUrl = KonstantaApi.formatUrlGambar(fotoList[idx]);

                return InkWell(
                  onTap: () => _pindahKeHalaman(idx),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: terpilih ? WarnaAplikasi.emasKlasik : WarnaAplikasi.garisBatas,
                        width: terpilih ? 2 : 1,
                      ),
                      boxShadow: terpilih
                          ? [
                              BoxShadow(
                                color: WarnaAplikasi.emasKlasik.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      fullThumbUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.local_florist_rounded,
                        size: 20,
                        color: WarnaAplikasi.coklatMawar,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
