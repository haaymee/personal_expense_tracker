import 'package:intl/intl.dart';
import 'dart:io';

String getFormattedCurrencyAmount(double amount) {
  var format = NumberFormat.currency(locale: "en_PH", name: "PHP", symbol: "₱", decimalDigits: 2);
  return format.format(amount);
}