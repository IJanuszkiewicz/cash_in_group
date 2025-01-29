import 'package:cash_in_group/core/user.dart';
import 'package:cash_in_group/features/groups/features/group/cubits/group_cubit.dart';
import 'package:cash_in_group/features/groups/features/group/cubits/group_state.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key, required this.loadedState});

  final GroupLoaded loadedState;

  @override
  Widget build(BuildContext context) {
    final groupCubit = BlocProvider.of<GroupCubit>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog(context, groupCubit);
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (buildContext, index) {
            final members = loadedState.details.members;
            if (index >= members.length) {
              return null;
            }
            return MemberTile(
              user: members[index],
              balances: loadedState.balances,
              currency: loadedState.details.currency,
            );
          },
        ),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, GroupCubit groupCubit) {
    final emailController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add User'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'User email'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final email = emailController.text;
                if (email.isNotEmpty) {
                  await groupCubit.addMember(email);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class MemberTile extends StatelessWidget {
  const MemberTile({
    required this.user,
    required this.balances,
    required this.currency,
    super.key,
  });

  final User user;
  final Map<String, Decimal>? balances;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          radius: 20,
          child: FlutterLogo(
            size: 30,
          ),
        ),
        title: Text(user.name),
        trailing: Text(
          "${balances?[user.id]?.toStringAsFixed(2) ?? "0.00"} $currency",
        ),
      ),
    );
  }
}
