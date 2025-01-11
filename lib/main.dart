import 'package:cash_in_group/features/groups/data/groups_repository.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_repository.dart';
import 'package:cash_in_group/features/groups/features/group/presentation/widgets/expenses_screen.dart';
import 'package:cash_in_group/features/groups/presentation/widgets/groups_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MainApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => GroupsScreen(),
      routes: [
        GoRoute(
            path: 'groups',
            builder: (context, state) => GroupsScreen(),
            routes: [
              GoRoute(
                path: '/:groupId',
                builder: (context, state) {
                  final groupId = state.pathParameters['groupId'];
                  if (groupId == null) throw Exception("there should be id");
                  return ExpensesScreen(groupId: groupId);
                },
              )
            ])
      ],
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GroupRepository>(
            create: (_) => MockGroupRepository()),
        RepositoryProvider<GroupsRepository>(
            create: (_) => MockGroupsRepository()),
      ],
      child: MaterialApp.router(
        title: "CashInGroup",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink,
            brightness: Brightness.light,
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}
