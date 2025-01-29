import 'package:cash_in_group/features/groups/data/group.dart';
import 'package:cash_in_group/mocks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class GroupsRepository {
  Future<List<Group>> getUsersGroups(String userId);
  Future<void> createGroup(
    String groupName,
    String userId,
    String currency,
    String? imageUrl,
  );
  Stream<List<Group>> getUsersGroupsStream(String userId);
}

class MockGroupsRepository implements GroupsRepository {
  @override
  Future<List<Group>> getUsersGroups(String userId) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return Mocks.groups
        .map((group) => Group(id: group.id, name: group.name))
        .toList();
  }

  @override
  Future<void> createGroup(
    String groupName,
    String userId,
    String currency,
    String? imageUrl,
  ) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Group>> getUsersGroupsStream(String userId) async* {
    await Future<void>.delayed(const Duration(seconds: 3));
    yield Mocks.groups
        .map((group) => Group(id: group.id, name: group.name))
        .toList();
  }
}

const String groupsCollection = 'groups';

class FirebaseGroupsRepository implements GroupsRepository {
  FirebaseGroupsRepository() : _firestore = FirebaseFirestore.instance {
    _groupsCollection = _firestore.collection(groupsCollection);
  }
  final FirebaseFirestore _firestore;
  late final CollectionReference _groupsCollection;

  @override
  Future<List<Group>> getUsersGroups(String userId) {
    return _groupsCollection.where('members', arrayContains: userId).get().then(
          (value) => value.docs
              .map((e) => Group(id: e.id, name: e['name'] as String))
              .toList(),
        );
  }

  @override
  Future<void> createGroup(
    String groupName,
    String userId,
    String currency,
    String? imageUrl,
  ) {
    return _groupsCollection.add({
      'name': groupName,
      'members': [userId],
      'currency': currency,
      'imageUrl': imageUrl,
    });
  }

  @override
  Stream<List<Group>> getUsersGroupsStream(String userId) {
    return _groupsCollection
        .where('members', arrayContains: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Group(
                  id: doc.id,
                  name: doc['name'] as String,
                  imageUrl: doc['imageUrl'] as String?,
                ),
              )
              .toList(),
        );
  }
}
