import 'package:cash_in_group/core/user.dart';
import 'package:cash_in_group/features/groups/features/group/cubits/group_state.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key, required this.loadedState});

  final GroupLoaded loadedState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        trailing:
            Text("${balances?[user.id]?.toStringAsFixed(2) ?? ""} $currency"),
      ),
    );
  }
}
