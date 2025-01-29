import 'package:cash_in_group/core/model.dart';
import 'package:cash_in_group/core/user.dart';
import 'package:cash_in_group/features/groups/features/group/data/expense.dart';

class GroupDetails extends Model<GroupDetails> {
  GroupDetails({
    required this.id,
    required this.name,
    required this.members,
    required this.expenses,
    required this.currency,
  });

  final String id;
  final String name;
  final List<User> members;
  final List<Expense> expenses;
  final String currency;

  @override
  GroupDetails fromJson(Map<String, Object> json) {
    return GroupDetails(
      id: json['id']! as String,
      name: name,
      members: members,
      expenses: expenses,
      currency: currency,
    );
  }

  @override
  Map<String, Object> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
