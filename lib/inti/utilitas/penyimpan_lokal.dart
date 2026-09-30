import 'package:shared_preferences/shared_preferences.dart';

class PenyimpanLokal {
  static const String _kunciToken = 'jwt_token_webee';
  static const String _kunciIdPengguna = 'id_pengguna';
  static const String _kunciNama = 'nama_pengguna';
  static const String _kunciEmail = 'email_pengguna';
  static const String _kunciPeran = 'peran_pengguna';

  static Future<void> simpanSesi({
    required String token,
    required int idPengguna,
    required String nama,
    required String email,
    required String peran,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kunciToken, token);
    await prefs.setInt(_kunciIdPengguna, idPengguna);
    await prefs.setString(_kunciNama, nama);
    await prefs.setString(_kunciEmail, email);
    await prefs.setString(_kunciPeran, peran);
  }

  static Future<String?> ambilToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kunciToken);
  }

  static Future<String?> ambilPeran() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kunciPeran);
  }

  static Future<String?> ambilNama() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kunciNama);
  }

  static Future<String?> ambilEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kunciEmail);
  }

  static Future<bool> apakahSudahLogin() async {
    final token = await ambilToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> hapusSesi() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
