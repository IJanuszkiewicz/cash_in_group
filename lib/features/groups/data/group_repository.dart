import 'dart:io';

import 'package:cash_in_group/features/groups/data/group.dart';

abstract class GroupRepository {
  Future<List<Group>> getUsersGroups(String userId);
}

class MockGroupRepository implements GroupRepository {
  @override
  Future<List<Group>> getUsersGroups(String userId) async {
    sleep(Duration(seconds: 3));
    return [
      Group(id: '0', name: 'Wycieczka Marki'),
      Group(id: '1', name: 'Dom')
    ];
  }
}
