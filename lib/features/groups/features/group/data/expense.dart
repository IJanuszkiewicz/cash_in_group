import 'package:cash_in_group/core/model.dart';
import 'package:cash_in_group/core/user.dart';
import 'package:decimal/decimal.dart';

class Expense implements Model<Expense> {
  Expense(this.id, this.title, this.paidById, this.amount, this.participantsIds,
      this.groupId, this.date);

  final String id;
  final String title;
  final String paidById;
  final Decimal amount;
  final List<String> participantsIds;
  final String groupId;
  final DateTime date;

  @override
  Expense fromJson(Map<String, Object> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, Object> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
