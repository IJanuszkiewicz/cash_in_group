import 'package:cash_in_group/core/user.dart';
import 'package:cash_in_group/features/groups/features/group/cubits/group_state.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class SettlementsScreen extends StatelessWidget {
  const SettlementsScreen({super.key, required this.loadedState});

  final GroupLoaded loadedState;

  @override
  Widget build(BuildContext context) {
    final settlements = loadedState.settlements;

    return Padding(
      padding: EdgeInsets.all(10),
      child: settlements.isEmpty
          ? Center(
              child: Text(
                "Everybody is settled!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: settlements.length,
              itemBuilder: (buildContext, index) {
                var settlement = settlements[index];
                var from = loadedState.details.members
                    .firstWhere((u) => u.id == settlement.from);
                var to = loadedState.details.members
                    .firstWhere((u) => u.id == settlement.to);
                return SettlementTile(
                  from: from,
                  to: to,
                  amount: settlement.amount,
                  currency: loadedState.details.currency,
                );
              },
            ),
    );
  }
}

class SettlementTile extends StatelessWidget {
  const SettlementTile(
      {super.key,
      required this.from,
      required this.to,
      required this.amount,
      required this.currency});

  final User from;
  final User to;
  final Decimal amount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
            "${from.name} owes ${to.name} ${amount.toStringAsFixed(2)} $currency"),
      ),
    );
  }
}
