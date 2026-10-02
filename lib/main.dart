import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webee_florist/fitur/landing_page/presentasi/halaman/halaman_landing_web.dart';
import 'package:webee_florist/inti/tema/tema_aplikasi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: AplikasiWebeeFlorist(),
    ),
  );
}

class AplikasiWebeeFlorist extends ConsumerWidget {
  const AplikasiWebeeFlorist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Webee Florist by utiy — Rangkaian Bunga Klasik Romantis',
      debugShowCheckedModeBanner: false,
      theme: TemaAplikasi.temaTerang,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
        },
      ),
      home: const HalamanLandingWeb(),
    );
  }
}
