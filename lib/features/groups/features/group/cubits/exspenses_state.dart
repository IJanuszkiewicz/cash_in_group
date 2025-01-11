import 'package:cash_in_group/features/groups/features/group/data/group_details.dart';

sealed class ExspensesState {}

class ExspensesLoading extends ExspensesState {}

class ExpensesLoaded extends ExspensesState {
  ExpensesLoaded({required this.details});

  final GroupDetails details;
}

class ExpensesError extends ExspensesState {
  final String message;

  ExpensesError(this.message);
}
