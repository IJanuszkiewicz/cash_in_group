import 'package:cash_in_group/core/user.dart';
import 'package:cash_in_group/features/groups/features/group/data/expense.dart';

class GroupDetails {
  GroupDetails({
    required this.id,
    required this.name,
    required this.members,
    required this.expenses,
  });

  final String id;
  final String name;
  final List<User> members;
  final List<Expense> expenses;
}
