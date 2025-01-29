import 'package:cash_in_group/core/user.dart';
import 'package:cash_in_group/features/groups/features/group/data/expense.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_details.dart';
import 'package:decimal/decimal.dart';

class Mocks {
  static final List<User> users = [
    User(name: 'Tony Dripano', id: '0', email: 'tony@example.com'),
    User(name: 'Mario Pudzianini', id: '1', email: 'mario@example.com'),
    User(name: 'Ben Dover', id: '2', email: 'ben@example.com'),
  ];

  static final List<GroupDetails> groups = [
    GroupDetails(
      id: '0',
      name: 'Wycieczka Marki',
      members: [users[0], users[1], users[2]],
      expenses: [
        Expense(
          '0',
          'Beer',
          '0',
          Decimal.parse('50.0'),
          [users[0].id, users[1].id],
          '0',
          DateTime.now(),
        ),
        Expense(
          '1',
          'Petrol',
          '2',
          Decimal.parse('150.0'),
          [users[0].id, users[1].id, users[2].id],
          '0',
          DateTime.now(),
        ),
        Expense(
          '2',
          'Groceries',
          '1',
          Decimal.parse('100.0'),
          [users[0].id, users[1].id, users[2].id],
          '0',
          DateTime.now().subtract(
            const Duration(days: 1),
          ),
        ),
      ],
      currency: 'zł',
    ),
    GroupDetails(
      id: '1',
      name: 'Dom',
      members: [users[0], users[1]],
      expenses: [],
      currency: 'zł',
    ),
  ];
}
