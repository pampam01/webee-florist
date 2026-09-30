import 'package:intl/intl.dart';

class FormatRupiah {
  FormatRupiah._();

  static final NumberFormat _pemformat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String format(num? nominal) {
    if (nominal == null) return 'Rp 0';
    return _pemformat.format(nominal);
  }
}
