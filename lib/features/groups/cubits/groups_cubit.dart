import 'package:cash_in_group/features/groups/data/group.dart';
import 'package:cash_in_group/features/groups/data/groups_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupsCubit extends Cubit<List<Group>?> {
  GroupsCubit(this._groupRepository, this._userId, [super.initialState]);

  final GroupsRepository _groupRepository;
  final String _userId;

  Future<void> fetch() async {
    final groups = await _groupRepository.getUsersGroups(_userId);
    emit(groups);
  }
}
