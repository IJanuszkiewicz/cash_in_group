import 'package:cash_in_group/features/groups/features/group/data/expense.dart';
import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({required this.expense, super.key, required this.currency});

  final Expense expense;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          radius: 30,
          child: FlutterLogo(
            size: 40,
          ),
        ),
        title: Text(expense.title),
        subtitle: Text('${expense.amount.toStringAsFixed(2)} $currency'),
        trailing: Image.network('https://picsum.photos/250?image=9'),
      ),
    );
  }
}
