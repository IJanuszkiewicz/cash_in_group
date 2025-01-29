import 'package:decimal/decimal.dart';

class Expense {
  Expense(this.id, this.title, this.paidById, this.amount, this.participantsIds,
      this.groupId, this.date);

  final String id;
  final String title;
  final String paidById;
  final Decimal amount;
  final List<String> participantsIds;
  final String groupId;
  final DateTime date;

  static Expense fromJson(Map<String, Object> json) {
    return Expense(
      json['id'] as String,
      json['title'] as String,
      json['paidBy'] as String,
      Decimal.parse(json['amount'] as String),
      List<String>.from(json['participants'] as List),
      json['groupId'] as String,
      DateTime.parse(json['date'] as String),
    );
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'title': title,
      'paidBy': paidById,
      'amount': amount.toString(),
      'participants': participantsIds,
      'groupId': groupId,
      'date': date.toIso8601String(),
    };
  }
}
