import 'package:cash_in_group/core/widgets/base_screen.dart';
import 'package:cash_in_group/features/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Center(
        child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Cash In Group!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (state is SignedInState)
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/groups');
                  },
                  child: Text('Go to Groups'),
                )
              else ...[
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/login');
                  },
                  child: Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/register');
                  },
                  child: Text('Register'),
                ),
              ]
            ],
          );
        }),
      ),
      title: 'Cash in Group',
    );
  }
}
