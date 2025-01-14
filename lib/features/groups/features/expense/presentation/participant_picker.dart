import 'package:cash_in_group/core/user.dart';
import 'package:cash_in_group/features/groups/features/expense/cubits/new_expense_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParticipantPicker extends StatelessWidget {
  const ParticipantPicker(
      {required this.participants, required this.users, super.key});

  final List<User> users;
  final List<String> participants;

  @override
  Widget build(BuildContext context) {
    final newExpenseCubit = BlocProvider.of<NewExpenseCubit>(context);
    return Column(
      children: users
          .map(
            (u) => Column(
              children: [
                CheckboxListTile(
                  title: Text(u.name),
                  value: participants.contains(u.id),
                  onChanged: (value) {
                    if (value == null) return;
                    if (value) {
                      newExpenseCubit.addParticipant(u.id);
                    } else {
                      newExpenseCubit.removeParticipant(u.id);
                    }
                  },
                ),
                Divider()
              ],
            ),
          )
          .toList(),
    );
  }
}
