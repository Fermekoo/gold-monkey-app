import 'package:intl/intl.dart';

class AppFormatters {
  static String crypto(double value) {
    final formatter = NumberFormat("#,##0.########", "en_US");
    return formatter.format(value);
  }

  static String currency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'en_US', 
      symbol: '\$', 
      decimalDigits: 2
    );
    return formatter.format(value);
  }
}