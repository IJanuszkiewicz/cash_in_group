import 'package:cash_in_group/core/widgets/base_screen.dart';
import 'package:cash_in_group/features/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => BaseScreen(
        title: 'Profile',
        child: Center(
          child: TextButton(
            onPressed: () {
              authCubit.signOut();
            },
            child: Text("Sign out"),
          ),
        ),
      ),
    );
  }
}
