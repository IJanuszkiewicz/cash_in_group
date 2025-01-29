import 'package:cash_in_group/core/widgets/base_screen.dart';
import 'package:cash_in_group/features/groups/features/group/cubits/group_cubit.dart';
import 'package:cash_in_group/features/groups/features/group/cubits/group_state.dart';
import 'package:cash_in_group/features/groups/features/group/data/expense.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_details.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_repository.dart';
import 'package:cash_in_group/features/groups/features/group/presentation/widgets/expense_tile.dart';
import 'package:cash_in_group/features/groups/features/group/presentation/widgets/expenses_screen.dart';
import 'package:cash_in_group/features/groups/features/group/presentation/widgets/members_screen.dart';
import 'package:cash_in_group/features/groups/features/group/presentation/widgets/settlements_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({required this.groupId, super.key});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GroupCubit(groupId, context.read<GroupRepository>())..fetch(),
      child: BlocBuilder<GroupCubit, GroupState>(
          builder: (buildContext, state) => switch (state) {
                GroupLoading() => BaseScreen(
                    title: "Group details",
                    child: Center(
                        child: LoadingAnimationWidget.inkDrop(
                            color: Colors.white, size: 40)),
                  ),
                GroupError(message: var m) => BaseScreen(
                    title: 'Error',
                    child: Center(
                      child: Text(
                        m,
                      ),
                    ),
                  ),
                GroupLoaded() => _loaded(state)
              }),
    );
  }

  Widget _loaded(GroupLoaded state) {
    return DefaultTabController(
        length: 3,
        child: BaseScreen(
          title: state.details.name,
          appBarBottom: TabBar(
            tabs: [
              Tab(text: "Expenses"),
              Tab(
                text: "Members",
              ),
              Tab(
                text: "Settlements",
              )
            ],
          ),
          child: TabBarView(children: [
            ExpensesScreen(loadedState: state),
            MembersScreen(loadedState: state),
            SettlementsScreen(loadedState: state),
          ]),
        ));
  }
}
