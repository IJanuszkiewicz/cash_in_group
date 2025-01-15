import 'package:cash_in_group/features/groups/features/group/cubits/group_cubit.dart';
import 'package:cash_in_group/features/groups/features/group/cubits/group_state.dart';
import 'package:cash_in_group/features/groups/features/group/presentation/widgets/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key, required this.loadedState});

  final GroupLoaded loadedState;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => BlocProvider.of<GroupCubit>(context).reload(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.go('/groups/${loadedState.details.id}/new_expense');
          },
          child: Icon(Icons.add),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(itemBuilder: (buildContext, index) {
            final expenses = loadedState.grouped;
            if (index >= expenses.keys.length) return null;
            final key = expenses.keys.toList()[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateSeparator(key),
                ...expenses[key]!
                    .map((expense) => ExpenseTile(expense: expense)),
              ],
            );
          }),
        ),
      ),
    );
    ;
  }

  Widget _buildDateSeparator(DateTime date) {
    final formattedDate = DateFormat.yMMMMd().format(date);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: double.infinity,
      child: Text(
        formattedDate,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
