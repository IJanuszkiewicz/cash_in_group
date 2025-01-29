import 'package:cash_in_group/core/widgets/base_screen.dart';
import 'package:cash_in_group/features/auth/auth_cubit.dart';
import 'package:cash_in_group/features/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is SignedInState) {
          return BaseScreen(
            title: 'Profile',
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: authCubit.userName,
                    builder: (context, s) => Text(
                      'Name: ${s.data}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${state.email}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Theme',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    title: const Text('System'),
                    leading: Radio<ThemeMode>(
                      value: ThemeMode.system,
                      groupValue: themeProvider.themeMode,
                      onChanged: (value) {
                        themeProvider.setThemeData(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Light'),
                    leading: Radio<ThemeMode>(
                      value: ThemeMode.light,
                      groupValue: themeProvider.themeMode,
                      onChanged: (value) {
                        themeProvider.setThemeData(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Dark'),
                    leading: Radio<ThemeMode>(
                      value: ThemeMode.dark,
                      groupValue: themeProvider.themeMode,
                      onChanged: (value) {
                        themeProvider.setThemeData(value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: authCubit.signOut,
                      child: const Text('Sign out'),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
