import 'dart:math';

import 'package:cash_in_group/features/groups/features/expense/data/new_expense.dart';
import 'package:cash_in_group/features/groups/features/group/data/expense.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_details.dart';
import 'package:cash_in_group/mocks.dart';

abstract class GroupRepository {
  Future<GroupDetails?> getDetails(String groupId);
  Future<Expense> addExpense(NewExpense newExpense);
}

class MockGroupRepository implements GroupRepository {
  @override
  Future<GroupDetails?> getDetails(String groupId) async {
    await Future.delayed(Duration(seconds: 3));
    final index = Mocks.groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return null;
    return Mocks.groups[index];
  }

  Future<Expense> addExpense(NewExpense newExpense) async {
    // server side validation mock
    if (newExpense.title == null ||
        newExpense.paidById == null ||
        newExpense.amount == null ||
        newExpense.participantsIds == null ||
        newExpense.participantsIds!.isEmpty ||
        newExpense.date == null) {
      throw Exception("Invalid data");
    }
    final expense = Expense(
      Random().nextInt(1000000000).toString(),
      newExpense.title!,
      newExpense.paidById!,
      newExpense.amount!,
      newExpense.participantsIds!,
      newExpense.groupId,
      newExpense.date!,
    );
    final details = await getDetails(newExpense.groupId);
    if (details == null) {
      throw Exception("Group not found");
    }
    details.expenses.add(expense);
    return expense;
  }
}
