import 'package:cash_in_group/features/groups/cubits/groups_cubit.dart';
import 'package:cash_in_group/features/groups/data/group_repository.dart';
import 'package:cash_in_group/features/groups/presentation/widgets/groups_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CashInGroup",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.light,
        ),
      ),
      home: BlocProvider(
        create: (context) => GroupsCubit(MockGroupRepository(), '0'),
        child: GroupsScreen(),
      ),
    );
  }
}
