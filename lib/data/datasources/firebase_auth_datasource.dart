import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:messenger/domain/utils/errors.dart';

class FirebaseAuthDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  Future<firebase_auth.User?> signUp(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw getFirebaseAuthErrorMessage(e.code, e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<firebase_auth.User?> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw getFirebaseAuthErrorMessage(e.code, e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Stream<firebase_auth.User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }
}
