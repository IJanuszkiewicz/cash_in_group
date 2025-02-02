import 'package:cash_in_group/core/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UsersRepository {
  Future<User?> getUser(String userId);
  Future<void> updateUser(User user);

  void addUser(String uid, String email, String name) {}
}

class FirebaseUsersRepository implements UsersRepository {
  FirebaseUsersRepository() : _firestore = FirebaseFirestore.instance {
    _usersCollection = _firestore.collection('users');
  }
  final FirebaseFirestore _firestore;
  late final CollectionReference _usersCollection;

  @override
  Future<User> getUser(String userId) {
    return _usersCollection.doc(userId).get().then((value) {
      return User(
        name: value['name'] as String,
        id: value.id,
        email: value['email'] as String,
      );
    });
  }

  @override
  Future<void> updateUser(User user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  void addUser(String uid, String email, String name) {
    _usersCollection.doc(uid).set({
      'email': email,
      'name': name,
    });
  }
}
