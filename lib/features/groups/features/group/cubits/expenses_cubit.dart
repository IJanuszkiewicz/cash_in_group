import 'package:cash_in_group/features/groups/features/group/cubits/exspenses_state.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesCubit extends Cubit<ExspensesState> {
  ExpensesCubit(this.groupId, this._groupRepository)
      : super(ExspensesLoading());
  final String groupId;
  final GroupRepository _groupRepository;

  Future<void> fetch() async {
    emit(ExspensesLoading());
    final details = await _groupRepository.getDetails(groupId);
    if (details == null) {
      emit(ExpensesError("Group not found"));
      return;
    }
    emit(ExpensesLoaded(details: details));
  }
}
