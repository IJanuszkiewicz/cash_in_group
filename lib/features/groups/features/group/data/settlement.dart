import 'package:decimal/decimal.dart';

class Settlement {
  final String from;
  final String to;
  final Decimal amount;

  Settlement({required this.from, required this.to, required this.amount});
}
