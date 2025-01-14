import 'package:decimal/decimal.dart';

class NewExpense {
  final String? title;
  final String? paidById;
  final Decimal? amount;
  final List<String>? participantsIds;
  final String groupId;
  final DateTime? date;

  NewExpense(
    this.groupId, [
    this.title,
    this.paidById,
    this.amount,
    this.participantsIds,
    this.date,
  ]);
}
