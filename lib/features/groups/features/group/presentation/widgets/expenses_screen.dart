import 'package:cash_in_group/core/widgets/base_screen.dart';
import 'package:cash_in_group/features/groups/features/group/cubits/expenses_cubit.dart';
import 'package:cash_in_group/features/groups/features/group/cubits/exspenses_state.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_details.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_repository.dart';
import 'package:cash_in_group/features/groups/features/group/presentation/widgets/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
                ExpensesLoaded(details: var details) => _fromDetails(details)
              }),
    );
  }

  Widget _fromDetails(GroupDetails details) {
    return BaseScreen(
      title: details.name,
      floatingActionButton: FloatingActionButton(
        // TODO: make new expense form
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(itemBuilder: (buildContext, index) {
          if (index >= details.expenses.length) return null;
          return ExpenseTile(expense: details.expenses[index]);
        }),
      ),
    );
  }
}
