import 'package:cash_in_group/core/user.dart';
import 'package:cash_in_group/features/groups/features/group/data/expense.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_details.dart';
import 'package:decimal/decimal.dart';

class Mocks {
  static final List<User> users = [
    User("Tony Dripano", '0'),
    User("Mario Pudzianini", '1'),
    User("Ben Dover", '2')
  ];

  static final List<GroupDetails> groups = [
    GroupDetails(
      id: '0',
      name: 'Wycieczka Marki',
      members: [users[0], users[1], users[2]],
      expenses: [
        Expense("0", "Beer", '0', Decimal.parse('50.0'),
            [users[0].id, users[1].id], '0', DateTime.now()),
        Expense("1", "Petrol", '2', Decimal.parse('150.0'),
            [users[0].id, users[1].id, users[2].id], '0', DateTime.now()),
        Expense(
          "2",
          "Groceries",
          '1',
          Decimal.parse('100.0'),
          [users[0].id, users[1].id, users[2].id],
          '0',
          DateTime.now().subtract(
            Duration(days: 1),
          ),
        ),
      ],
    ),
    GroupDetails(
      id: '1',
      name: 'Dom',
      members: [users[0], users[1]],
      expenses: [],
    ),
  ];
}
