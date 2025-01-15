import 'package:cash_in_group/features/groups/features/group/cubits/group_state.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit(this.groupId, this._groupRepository) : super(GroupLoading());
  final String groupId;
  final GroupRepository _groupRepository;

  Future<void> fetch() async {
    emit(GroupLoading());
    await reload();
  }

  Future<void> reload() async {
    final details = await _groupRepository.getDetails(groupId);
    if (details == null) {
      emit(GroupError("Group not found"));
      return;
    }
    emit(GroupLoaded(details: details));
  }
}
