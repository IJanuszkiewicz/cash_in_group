import 'package:cash_in_group/core/user.dart';
import 'package:cash_in_group/features/groups/features/expense/data/new_expense.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_details.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class NewExpenseState {}

class NewExpenseStateLoading extends NewExpenseState {}

class NewExpenseStateError extends NewExpenseState {
  NewExpenseStateError(this.error);
  final String error;
}

class NewExpenseStateLoaded extends NewExpenseState {
  NewExpenseStateLoaded({required this.newExpense, required this.groupDetails});

  NewExpense newExpense;
  GroupDetails groupDetails;
}

class NewExpenseCubit extends Cubit<NewExpenseState> {
  NewExpenseCubit(
    this._groupRepository,
    this.groupId,
  ) : super(NewExpenseStateLoading());

  final GroupRepository _groupRepository;
  final String groupId;

  Future<void> fetch() async {
    final details = await _groupRepository.getDetails(groupId);
    if (details == null) {
      emit(NewExpenseStateError("Group not found"));
      return;
    }

    emit(
      NewExpenseStateLoaded(
          newExpense: NewExpense(
            groupId,
            participantsIds: details.members.map((u) => u.id).toList(),
          ),
          groupDetails: details),
    );
  }

  Future<List<String>> addExpense(
      String title, String amount, String paidBy) async {
    if (state is NewExpenseStateLoaded) {
      try {
        final newExpense = (state as NewExpenseStateLoaded).newExpense;
        newExpense.title = title;
        newExpense.amount = Decimal.parse(amount);
        newExpense.date = DateTime.now();
        newExpense.paidById = paidBy;

        final expnese = await _groupRepository.addExpense(newExpense);
        return [];
      } on Exception catch (e) {
        return [e.toString()];
      } catch (e) {
        return ["Error accured"];
      }
    }
    return ["No data"];
  }

  void addParticipant(String userId) {
    if (state is! NewExpenseStateLoaded) {
      throw ErrorDescription("Can't add member when state hasn't loaded");
    }
    final loaded = (state as NewExpenseStateLoaded);
    loaded.newExpense.participantsIds ??= [];
    if (loaded.newExpense.participantsIds!.contains(userId)) return;
    loaded.newExpense.participantsIds!.add(userId);
    emit(NewExpenseStateLoaded(
        newExpense: loaded.newExpense, groupDetails: loaded.groupDetails));
  }

  void removeParticipant(String userId) {
    if (state is! NewExpenseStateLoaded) {
      throw ErrorDescription("Can't add member when state hasn't loaded");
    }
    final loaded = (state as NewExpenseStateLoaded);
    loaded.newExpense.participantsIds ??= [];
    if (loaded.newExpense.participantsIds!.contains(userId)) {
      loaded.newExpense.participantsIds!.remove(userId);
    }
    emit(NewExpenseStateLoaded(
        newExpense: loaded.newExpense, groupDetails: loaded.groupDetails));
  }
}
