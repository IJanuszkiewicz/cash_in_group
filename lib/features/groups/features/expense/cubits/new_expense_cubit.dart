import 'package:cash_in_group/features/groups/features/expense/data/new_expense.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseCubit extends Cubit<NewExpense> {
  ExpenseCubit(
    this._groupRepository,
    this.groupId,
  ) : super(NewExpense(groupId));

  final GroupRepository _groupRepository;
  final String groupId;
}
