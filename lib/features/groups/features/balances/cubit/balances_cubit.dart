import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class BalancesState {}

class BalancesCubit extends Cubit<BalancesState> {
  BalancesCubit(super.initialState);
}
