import 'package:firebase_auth/firebase_auth.dart' as firebase; // Userクラスの衝突を避ける

abstract class AuthRepository {
  Stream<firebase.User?> authStateChanges();
  firebase.User? getCurrentUser();
  Future<void> signUp({required String email, required String password});
  Future<void> signIn({required String email, required String password});
  Future<void> signOut();
  Future<void> sendEmailVerification();
}
