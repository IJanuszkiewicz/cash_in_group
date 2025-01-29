import 'package:cash_in_group/features/groups/features/group/data/expense.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_details.dart';
import 'package:cash_in_group/features/groups/features/group/data/settlement.dart';
import 'package:decimal/decimal.dart';

sealed class GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  GroupLoaded({
    required this.settlements,
    required this.details,
    required this.balances,
  }) {
    grouped = {};
    for (final expense in details.expenses) {
      final key =
          DateTime(expense.date.year, expense.date.month, expense.date.day);
      if (grouped.containsKey(key)) {
        grouped[key]!.add(expense);
      } else {
        grouped.putIfAbsent(key, () => [expense]);
      }
    }
    for (final key in grouped.keys) {
      grouped[key]!.sort(
        (a, b) => b.date.millisecondsSinceEpoch - a.date.millisecondsSinceEpoch,
      );
    }
  }

  final GroupDetails details;
  late Map<DateTime, List<Expense>> grouped;
  final Map<String, Decimal> balances;
  final List<Settlement> settlements;
}

class GroupError extends GroupState {
  GroupError(this.message);
  final String message;
}
