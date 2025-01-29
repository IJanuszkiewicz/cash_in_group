import 'package:decimal/decimal.dart';

class Settlement {
  Settlement({required this.from, required this.to, required this.amount});
  final String from;
  final String to;
  final Decimal amount;
}
