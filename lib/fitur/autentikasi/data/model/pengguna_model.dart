class PenggunaModel {
  final int id;
  final String nama;
  final String email;
  final String peran; // 'admin' atau 'pelanggan'
  final String? noTelepon;
  final String? alamat;
  final String? token;

  const PenggunaModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.peran,
    this.noTelepon,
    this.alamat,
    this.token,
  });

  bool get isAdmin => peran.toLowerCase() == 'admin';
  bool get isPelanggan => peran.toLowerCase() == 'pelanggan';

  factory PenggunaModel.fromJson(Map<String, dynamic> json, {String? tokenJwt}) {
    return PenggunaModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      peran: json['peran'] ?? 'pelanggan',
      noTelepon: json['no_telepon'],
      alamat: json['alamat'],
      token: tokenJwt ?? json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'peran': peran,
      'no_telepon': noTelepon,
      'alamat': alamat,
      'token': token,
    };
  }

  PenggunaModel copyWith({
    int? id,
    String? nama,
    String? email,
    String? peran,
    String? noTelepon,
    String? alamat,
    String? token,
  }) {
    return PenggunaModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      peran: peran ?? this.peran,
      noTelepon: noTelepon ?? this.noTelepon,
      alamat: alamat ?? this.alamat,
      token: token ?? this.token,
    );
  }
}
