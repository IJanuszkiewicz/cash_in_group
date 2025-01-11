import 'package:cash_in_group/features/groups/features/group/data/expense.dart';
import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({required this.expense, super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: FlutterLogo(
            size: 40,
          ),
        ),
        title: Text(expense.title),
        subtitle: Text(expense.amount.toString()),
        trailing: Image.network("https://picsum.photos/250?image=9"),
      ),
    );
  }
}
