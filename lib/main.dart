import 'package:cash_in_group/features/auth/auth_cubit.dart';
import 'package:cash_in_group/features/auth/auth_service.dart';
import 'package:cash_in_group/features/auth/login_screen.dart';
import 'package:cash_in_group/features/auth/register_screen.dart';
import 'package:cash_in_group/features/groups/data/groups_repository.dart';
import 'package:cash_in_group/features/groups/features/expense/presentation/add_expense_screen.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_repository.dart';
import 'package:cash_in_group/features/groups/features/group/presentation/widgets/group_screen.dart';
import 'package:cash_in_group/features/groups/presentation/widgets/add_group_screen.dart';
import 'package:cash_in_group/features/groups/presentation/widgets/groups_screen.dart';
import 'package:cash_in_group/features/profile/data/users_repository.dart';
import 'package:cash_in_group/features/profile/presentation/profile_screen.dart';
import 'package:cash_in_group/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const _App());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginScreen(),
      routes: [
        GoRoute(path: "login", builder: (context, state) => LoginScreen()),
        GoRoute(
            path: "register", builder: (context, state) => RegisterScreen()),
        GoRoute(path: 'profile', builder: (context, state) => ProfileScreen()),
        GoRoute(
            path: 'groups',
            builder: (context, state) => GroupsScreen(),
            routes: [
              GoRoute(
                  path: 'new', builder: (context, state) => AddGroupScreen()),
              GoRoute(
                path: '/:groupId',
                builder: (context, state) {
                  final groupId = state.pathParameters['groupId'];
                  if (groupId == null) throw Exception("there should be id");
                  return GroupScreen(groupId: groupId);
                },
                routes: [
                  GoRoute(
                    path: '/new_expense',
                    builder: (context, state) {
                      final groupId = state.pathParameters['groupId'];
                      if (groupId == null) {
                        throw Exception("there should be id");
                      }
                      return AddExpenseScreen(groupId: groupId);
                    },
                  ),
                ],
              )
            ])
      ],
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    final bool loggedIn = BlocProvider.of<AuthCubit>(context).isSignedIn();
    final bool loggingIn = state.matchedLocation == "/login";
    final bool signingIn = state.matchedLocation == "/register";
    if (!loggedIn) {
      if (signingIn) {
        return "/register";
      }
      return "/login";
    }
    if (loggingIn || signingIn) {
      return '/groups';
    }
    return null;
  },
);

class _App extends StatefulWidget {
  const _App();

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  final Future<FirebaseApp> _initialization =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "CashInGroup",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.light,
        ),
      ),
      routerConfig: _router,
      builder: (context, child) {
        return FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            return switch (snapshot.connectionState) {
              ConnectionState.done => MultiProvider(
                  providers: [
                    RepositoryProvider<GroupRepository>(
                      create: (_) => FirebaseGroupRepository(),
                    ),
                    RepositoryProvider<GroupsRepository>(
                      create: (_) => FirebaseGroupsRepository(),
                    ),
                    RepositoryProvider<UsersRepository>(
                        create: (_) => FirebaseUsersRepository()),
                  ],
                  child: MultiProvider(
                    providers: [
                      Provider(
                        create: (context) => AuthService(
                          firebaseAuth: FirebaseAuth.instance,
                          usersRepository: context.read(),
                        ),
                      ),
                      BlocProvider(
                        create: (context) =>
                            AuthCubit(authService: context.read()),
                      )
                    ],
                    child: BlocListener<AuthCubit, AuthState>(
                      listener: (BuildContext context, AuthState state) {
                        _router.refresh();
                      },
                      child: child,
                    ),
                  ),
                ),
              _ => const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            };
          },
        );
      },
    );
  }
}
