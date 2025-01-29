import 'package:flutter_bloc/flutter_bloc.dart';

class NewGroupCubit extends Cubit<NewGroupState> {
  NewGroupCubit(super.initialState);
}

sealed class NewGroupState {}

class NewGroupInitial extends NewGroupState {}

class NewGroupLoading extends NewGroupState {}

class NewGroupSuccess extends NewGroupState {}

class NewGroupFailure extends NewGroupState {}
