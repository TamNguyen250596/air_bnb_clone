import 'package:firebase_auth/firebase_auth.dart';

// ========== Auth Service ==========
class AuthService {
  // ========== Public Methods ==========
  Future<UserCredential> createUser(String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password
    );
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}