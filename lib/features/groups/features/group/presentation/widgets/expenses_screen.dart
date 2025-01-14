import 'package:cash_in_group/core/widgets/base_screen.dart';
import 'package:cash_in_group/features/groups/features/group/cubits/expenses_cubit.dart';
import 'package:cash_in_group/features/groups/features/group/cubits/exspenses_state.dart';
import 'package:cash_in_group/features/groups/features/group/data/expense.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_details.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_repository.dart';
import 'package:cash_in_group/features/groups/features/group/presentation/widgets/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({required this.groupId, super.key});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ExpensesCubit(groupId, context.read<GroupRepository>())..fetch(),
      child: BlocBuilder<ExpensesCubit, ExspensesState>(
          builder: (buildContext, state) => switch (state) {
                ExspensesLoading() => BaseScreen(
                    title: "Group details",
                    child: Center(
                        child: LoadingAnimationWidget.inkDrop(
                            color: Colors.white, size: 40)),
                  ),
                ExpensesError(message: var m) => BaseScreen(
                    title: 'Error',
                    child: Center(
                      child: Text(
                        m,
                      ),
                    ),
                  ),
                ExpensesLoaded(details: var details, grouped: var grouped) =>
                  _fromGrouped(grouped, details, buildContext)
              }),
    );
  }

  Widget _fromGrouped(Map<DateTime, List<Expense>> expenses,
      GroupDetails details, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => BlocProvider.of<ExpensesCubit>(context).reload(),
      child: BaseScreen(
        title: details.name,
        floatingActionButton: FloatingActionButton(
          // TODO: make new expense form
          onPressed: () {
            context.go('/groups/$groupId/new_expense');
          },
          child: Icon(Icons.add),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(itemBuilder: (buildContext, index) {
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
