import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../konstanta/konstanta_api.dart';
import '../utilitas/penyimpan_lokal.dart';

class KlienApi {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _buatKlienDio();
    return _dio!;
  }

  static Dio _buatKlienDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: KonstantaApi.urlDasar,
        connectTimeout: const Duration(milliseconds: KonstantaApi.waktuTenggangKoneksiMs),
        receiveTimeout: const Duration(milliseconds: KonstantaApi.waktuTenggangTerimaMs),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await PenyimpanLokal.ambilToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            debugPrint('[API REQ] ${options.method} -> ${options.uri}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('[API RES] ${response.statusCode} <- ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            debugPrint('[API ERR] ${e.response?.statusCode} <- ${e.message}');
          }
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
