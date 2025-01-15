import 'package:decimal/decimal.dart';

class NewExpense {
  String? title;
  String? paidById;
  Decimal? amount;
  List<String>? participantsIds;
  String groupId;
  DateTime? date;

  NewExpense(
    this.groupId, {
    this.title,
    this.paidById,
    this.amount,
    this.participantsIds,
    this.date,
  });
}
