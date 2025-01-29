import 'dart:math';

import 'package:cash_in_group/core/user.dart';
import 'package:cash_in_group/features/groups/features/expense/data/new_expense.dart';
import 'package:cash_in_group/features/groups/features/group/data/expense.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_details.dart';
import 'package:cash_in_group/mocks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';

abstract class GroupRepository {
  Future<GroupDetails?> getDetails(String groupId);
  Future<Expense> addExpense(NewExpense newExpense);
  Future<Map<String, Decimal>> getBalances(String groupId);
  Future<bool> addMember(String groupId, String email);

  Future<void> settle(
      String fromId, String toId, Decimal amount, String groupId) async {}
}

class FirebaseGroupRepository implements GroupRepository {
  final FirebaseFirestore _firestore;
  late final CollectionReference _groupsCollection;
  late final CollectionReference _usersCollection;

  static const String groupsCollection = 'groups';

  FirebaseGroupRepository() : _firestore = FirebaseFirestore.instance {
    _groupsCollection = _firestore.collection(groupsCollection);
    _usersCollection = _firestore.collection('users');
  }

  @override
  Future<Expense> addExpense(NewExpense newExpense) {
    return _groupsCollection
        .doc(newExpense.groupId)
        .collection('expenses')
        .add({
      'title': newExpense.title,
      'paidBy': newExpense.paidById,
      'amount': newExpense.amount.toString(),
      'participants': newExpense.participantsIds,
      'date': newExpense.date,
    }).then((value) {
      return Expense(
        value.id,
        newExpense.title!,
        newExpense.paidById!,
        newExpense.amount!,
        newExpense.participantsIds!,
        newExpense.groupId,
        newExpense.date!,
      );
    });
  }

  @override
  Future<Map<String, Decimal>> getBalances(String groupId) {
    return _groupsCollection
        .doc(groupId)
        .collection('expenses')
        .get()
        .then((value) {
      final result = <String, Decimal>{};
      for (var expense in value.docs) {
        var curr = result.putIfAbsent(
            expense['paidBy'] as String, () => Decimal.fromInt(0));
        result[expense['paidBy'] as String] =
            curr + Decimal.parse(expense['amount'].toString());
        var splitValue = Decimal.parse(expense['amount'].toString()) /
            Decimal.fromInt((expense['participants'] as List).length);
        for (var participantId in expense['participants'] as List) {
          var value = result.putIfAbsent(
              participantId as String, () => Decimal.fromInt(0));
          result[participantId] =
              value - splitValue.toDecimal(scaleOnInfinitePrecision: 10);
        }
      }
      return result;
    });
  }

  @override
  Future<GroupDetails?> getDetails(String groupId) async {
    final groupDoc = _groupsCollection.doc(groupId);
    final expensesCollection = groupDoc.collection('expenses');

    final expenses = await expensesCollection.get().then((value) {
      return value.docs.map((e) {
        return Expense(
          e.id,
          e['title'] as String,
          e['paidBy'] as String,
          Decimal.parse(e['amount'].toString()),
          List<String>.from(e['participants'] as List),
          groupId,
          (e['date'] as Timestamp).toDate(),
        );
      }).toList();
    });

    final groupSnapshot = await groupDoc.get();
    final members = <User>[];
    for (var member in groupSnapshot['members'] as List) {
      members
          .add(await _usersCollection.doc(member as String).get().then((value) {
        return User(
          name: value['name'] as String,
          id: value.id,
          email: value['email'] as String,
        );
      }));
    }
    return groupDoc.get().then((value) {
      if (!value.exists) return null;
      return GroupDetails(
        id: value.id,
        name: value['name'] as String,
        members: members,
        expenses: expenses,
        currency: value['currency'] as String,
      );
    });
  }

  @override
  Future<bool> addMember(String groupId, String email) {
    return _usersCollection
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isEmpty) return false;
      final userId = value.docs.first.id;
      return _groupsCollection.doc(groupId).update({
        'members': FieldValue.arrayUnion([userId])
      }).then((value) => true);
    });
  }

  @override
  Future<void> settle(
      String fromId, String toId, Decimal amount, String groupId) async {
    await addExpense(NewExpense(
      groupId,
      title: 'Settlement',
      paidById: fromId,
      amount: amount,
      participantsIds: [toId],
      date: DateTime.now(),
    ));
  }
}

class MockGroupRepository implements GroupRepository {
  @override
  Future<GroupDetails?> getDetails(String groupId) async {
    await Future.delayed(Duration(seconds: 1));
    final index = Mocks.groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return null;
    return Mocks.groups[index];
  }

  @override
  Future<Expense> addExpense(NewExpense newExpense) async {
    // server side validation mock
    if (newExpense.title == null ||
        newExpense.paidById == null ||
        newExpense.amount == null ||
        newExpense.participantsIds == null ||
        newExpense.participantsIds!.isEmpty ||
        newExpense.date == null) {
      throw Exception("Invalid data");
    }
    final expense = Expense(
      Random().nextInt(1000000000).toString(),
      newExpense.title!,
      newExpense.paidById!,
      newExpense.amount!,
      newExpense.participantsIds!,
      newExpense.groupId,
      newExpense.date!,
    );
    final details = await getDetails(newExpense.groupId);
    if (details == null) {
      throw Exception("Group not found");
    }
    details.expenses.add(expense);
    return expense;
  }

  @override
  Future<Map<String, Decimal>> getBalances(String groupId) async {
    final details = await getDetails(groupId);
    if (details == null) {
      throw Exception("Group not found");
    }
    final result = <String, Decimal>{};
    for (var expense in details.expenses) {
      var curr = result.putIfAbsent(expense.paidById, () => Decimal.fromInt(0));
      result[expense.paidById] = curr + expense.amount;
      var splitValue =
          expense.amount / Decimal.fromInt(expense.participantsIds.length);
      for (var participantId in expense.participantsIds) {
        var value = result.putIfAbsent(participantId, () => Decimal.fromInt(0));
        result[participantId] = value -
            splitValue.toDecimal(scaleOnInfinitePrecision: 10); // rounding here
      }
    }
    return result;
  }

  @override
  Future<bool> addMember(String groupId, String email) {
    final details = Mocks.groups.firstWhere((group) => group.id == groupId);
    final user = Mocks.users.firstWhere((user) => user.email == email);
    details.members.add(user);
    return Future.value(true);
  }

  @override
  Future<void> settle(
      String fromId, String toId, Decimal amount, String groupId) async {
    // TODO: implement settle
  }
}
