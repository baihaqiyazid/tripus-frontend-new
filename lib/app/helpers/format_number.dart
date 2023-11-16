import 'package:intl/intl.dart';

String formatNumber(double number) {
  final NumberFormat formatter = NumberFormat("#,###", "en_US");
  return formatter.format(number).replaceAll(',', '.');
}