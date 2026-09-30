sealed class HasilApi<T> {
  const HasilApi();
}

class ApiSukses<T> extends HasilApi<T> {
  final T data;
  final String pesan;
  const ApiSukses(this.data, {this.pesan = 'Berhasil'});
}

class ApiGagal<T> extends HasilApi<T> {
  final String pesanKesalahan;
  final int? kodeStatus;
  const ApiGagal(this.pesanKesalahan, {this.kodeStatus});
}

class ApiMemuat<T> extends HasilApi<T> {
  const ApiMemuat();
}
