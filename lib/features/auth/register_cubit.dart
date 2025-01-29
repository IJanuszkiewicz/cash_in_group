import 'package:cash_in_group/features/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required this.authService}) : super(RegisterState.initial());

  final AuthService authService;

  Future<void> registerWithEmail(
      String email, String password, String name) async {
    emit(RegisterState.loading());
    await Future<void>.delayed(const Duration(seconds: 1));

    try {
      final result = await authService.signUpWithEmail(email, password, name);
      if (result != null) {
        emit(RegisterState.error(result));
      } else {
        emit(RegisterState.success());
      }
    } catch (err) {
      emit(RegisterState.error('Unexpected error: $err'));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

class RegisterState {
  const RegisterState._({
    this.error,
    this.isLoading = false,
    this.isSuccess = false,
  });

  const RegisterState.initial() : this._();

  const RegisterState.loading() : this._(isLoading: true);

  const RegisterState.success() : this._(isSuccess: true);

  const RegisterState.error(String error) : this._(error: error);

  final String? error;
  final bool isLoading;
  final bool isSuccess;
}
