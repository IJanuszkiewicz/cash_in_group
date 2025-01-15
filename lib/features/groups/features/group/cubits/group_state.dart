import 'package:cash_in_group/features/groups/features/group/data/expense.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_details.dart';

sealed class GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  GroupLoaded({required this.details}) {
    grouped = {};
    for (var expense in details.expenses) {
      final key =
          DateTime(expense.date.year, expense.date.month, expense.date.day);
      if (grouped.containsKey(key)) {
        grouped[key]!.add(expense);
      } else {
        grouped.putIfAbsent(key, () => [expense]);
      }
    }
  }

  final GroupDetails details;
  late Map<DateTime, List<Expense>> grouped;
}

class GroupError extends GroupState {
  final String message;

  GroupError(this.message);
}
