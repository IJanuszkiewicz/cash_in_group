import 'package:cash_in_group/features/auth/auth_service.dart';
import 'package:cash_in_group/features/groups/data/groups_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewGroupCubit extends Cubit<NewGroupState> {
  NewGroupCubit(this.groupsRepository, this.authService)
      : super(NewGroupInitial());

  final GroupsRepository groupsRepository;
  final AuthService authService;

  Future<String?> _uploadImage(XFile imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('group_images/${imageFile.name}');
      final uploadTask = storageRef.putFile(File(imageFile.path));
      final snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } catch (err) {
      print('Error uploading image: $err');
      return null;
    }
  }

  void createGroup(String groupName, String currency, XFile? groupImage) async {
    emit(NewGroupLoading());
    try {
      String? imageUrl;
      if (groupImage != null) {
        imageUrl = await _uploadImage(groupImage);
      }
      await groupsRepository.createGroup(
        groupName,
        authService.currentUser!.uid,
        currency,
        imageUrl,
      );
      emit(NewGroupSuccess());
    } catch (err) {
      emit(NewGroupFailure(err.toString()));
    }
  }
}

sealed class NewGroupState {}

class NewGroupInitial extends NewGroupState {}

class NewGroupLoading extends NewGroupState {}

class NewGroupSuccess extends NewGroupState {}

class NewGroupFailure extends NewGroupState {
  NewGroupFailure(this.message);

  final String message;
}
