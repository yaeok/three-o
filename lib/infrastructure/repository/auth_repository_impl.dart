import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:three_o/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase.FirebaseAuth _firebaseAuth;
  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Stream<firebase.User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  @override
  firebase.User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
}
