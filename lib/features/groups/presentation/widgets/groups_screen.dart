import 'package:cash_in_group/core/widgets/base_screen.dart';
import 'package:cash_in_group/features/groups/cubits/groups_cubit.dart';
import 'package:cash_in_group/features/groups/data/group.dart';
import 'package:cash_in_group/features/groups/presentation/widgets/group_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groupsCubit = BlocProvider.of<GroupsCubit>(context);
    groupsCubit.fetch();
    return BaseScreen(
      title: "Groups",
      child: BlocBuilder<GroupsCubit, List<Group>?>(
          builder: (BuildContext context, List<Group>? state) {
        if (state == null) {
          return Center(
              child: LoadingAnimationWidget.inkDrop(
                  color: Colors.white, size: 40));
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              return groupsCubit.fetch();
            },
            child: ListView.builder(
              itemBuilder: (buildContext, index) => state.length > index
                  ? GroupTile(
                      groupName: state[index].name,
                      groupId: state[index].id,
                    )
                  : null,
            ),
          );
        }
      }),
    );
  }
}
