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
    var groupCubit = BlocProvider.of<GroupCubit>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog(context, groupCubit);
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(itemBuilder: (buildContext, index) {
          final members = loadedState.details.members;
          if (index >= members.length) return null;
          return MemberTile(
            user: members[index],
            balances: loadedState.balances,
            currency: loadedState.details.currency,
          );
        }),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, GroupCubit groupCubit) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add User'),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'User email'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Add user to the group
                final email = emailController.text;
                if (email.isNotEmpty) {
                  await groupCubit.addMember(email);
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class MemberTile extends StatelessWidget {
  const MemberTile(
      {required this.user,
      required this.balances,
      required this.currency,
      super.key});

  final User user;
  final Map<String, Decimal>? balances;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          child: FlutterLogo(
            size: 30,
          ),
        ),
        title: Text(user.name),
        trailing: Text(
            "${balances?[user.id]?.toStringAsFixed(2) ?? "0.00"} $currency"),
      ),
    );
  }
}
