import 'package:cash_in_group/features/groups/data/group.dart';
import 'package:cash_in_group/mocks.dart';

abstract class GroupsRepository {
  Future<List<Group>> getUsersGroups(String userId);
}

class MockGroupsRepository implements GroupsRepository {
  @override
  Future<List<Group>> getUsersGroups(String userId) async {
    await Future.delayed(Duration(seconds: 3));
    return Mocks.groups
        .map((group) => Group(id: group.id, name: group.name))
        .toList();
  }
}
