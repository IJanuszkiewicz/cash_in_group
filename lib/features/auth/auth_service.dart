import 'package:cash_in_group/features/profile/data/users_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum SignInResult {
  invalidEmail,
  userDisabled,
  userNotFound,
  wrongPassword,
  success,
}

class AuthService {
  const AuthService(
      {required this.usersRepository, required this.firebaseAuth});

  final FirebaseAuth firebaseAuth;
  final UsersRepository usersRepository;
  bool get isSignedIn => currentUser != null;

  Stream<bool> get isSignedInStream =>
      firebaseAuth.userChanges().map((user) => user != null);

  String get userEmail => currentUser!.email!;

  User? get currentUser => firebaseAuth.currentUser;

  Future<SignInResult> signInWithEmail(String email, String password) async {
    try {
      if (isSignedIn) {
        await firebaseAuth.signOut();
      }

      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return SignInResult.success;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return SignInResult.invalidEmail;
        case 'user-disabled':
          return SignInResult.userDisabled;
        case 'user-not-found' || 'invalid-credential':
          return SignInResult.userNotFound;
        case 'wrong-password':
          return SignInResult.wrongPassword;
        default:
          rethrow;
      }
    }
  }

  Future<String?> signUpWithEmail(String email, String password) async {
    try {
      if (isSignedIn) {
        await firebaseAuth.signOut();
      }

      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        return "Error occurred";
      }

      usersRepository.addUser(credential.user!.uid, email);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() => firebaseAuth.signOut();
}
