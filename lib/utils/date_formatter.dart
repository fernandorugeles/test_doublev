import 'package:intl/intl.dart';

class DateFormatter {
  static String toShortDate([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateFormat('dd/MM/yyyy').format(d);
  }

  static String toDateTime([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateFormat('dd/MM/yyyy HH:mm').format(d);
  }

  static DateTime fromShortDate(String value) {
    return DateFormat('dd/MM/yyyy').parse(value);
  }
}
