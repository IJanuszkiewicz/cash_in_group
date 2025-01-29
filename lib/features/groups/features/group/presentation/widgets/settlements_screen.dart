import 'package:cash_in_group/core/user.dart';
import 'package:cash_in_group/features/auth/auth_cubit.dart';
import 'package:cash_in_group/features/groups/features/group/cubits/group_cubit.dart';
import 'package:cash_in_group/features/groups/features/group/cubits/group_state.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettlementsScreen extends StatelessWidget {
  const SettlementsScreen({super.key, required this.loadedState});

  final GroupLoaded loadedState;

  @override
  Widget build(BuildContext context) {
    final settlements = loadedState.settlements;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: settlements.isEmpty
          ? const Center(
              child: Text(
                'Everybody is settled!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: settlements.length,
              itemBuilder: (buildContext, index) {
                final settlement = settlements[index];
                final from = loadedState.details.members
                    .firstWhere((u) => u.id == settlement.from);
                final to = loadedState.details.members
                    .firstWhere((u) => u.id == settlement.to);
                return SettlementTile(
                  from: from,
                  to: to,
                  amount: settlement.amount,
                  currency: loadedState.details.currency,
                  groupId: loadedState.details.id,
                );
              },
            ),
    );
  }
}

class SettlementTile extends StatelessWidget {
  const SettlementTile({
    super.key,
    required this.from,
    required this.to,
    required this.amount,
    required this.currency,
    required this.groupId,
  });

  final User from;
  final User to;
  final Decimal amount;
  final String currency;
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${from.name} owes ${to.name} ${amount.toStringAsFixed(2)} $currency',
            ),
            if (BlocProvider.of<AuthCubit>(context).userUid == from.id)
              ElevatedButton(
                onPressed: () async {
                  await RepositoryProvider.of<GroupRepository>(context)
                      .settle(from.id, to.id, amount, groupId);
                  await BlocProvider.of<GroupCubit>(context).fetch();
                },
                child: const Text('Settle'),
              ),
          ],
        ),
      ),
    );
  }
}
