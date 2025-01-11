import 'package:cash_in_group/features/groups/features/group/data/group_details.dart';
import 'package:cash_in_group/mocks.dart';

abstract class GroupRepository {
  Future<GroupDetails?> getDetails(String groupId);
}

class MockGroupRepository implements GroupRepository {
  @override
  Future<GroupDetails?> getDetails(String groupId) async {
    await Future.delayed(Duration(seconds: 3));
    final index = Mocks.groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return null;
    return Mocks.groups[index];
  }
}
