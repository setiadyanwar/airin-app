import 'package:intl/intl.dart';

class Formatters {
  static String formatRupiah(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatDate(dynamic date) {
    if (date == null) return '';
    DateTime parsed;
    if (date is DateTime) {
      parsed = date;
    } else if (date is String) {
      parsed = DateTime.tryParse(date) ?? DateTime.now();
    } else {
      return '';
    }
    try {
      return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(parsed);
    } catch (_) {
      try {
        return DateFormat('d MMM yyyy, HH:mm').format(parsed);
      } catch (_) {
        return '${parsed.day}/${parsed.month}/${parsed.year}';
      }
    }
  }

  static int calculateDiscountPercent(num originalPrice, num salePrice) {
    if (originalPrice <= 0 || salePrice >= originalPrice) return 0;
    return (((originalPrice - salePrice) / originalPrice) * 100).round();
  }
}

