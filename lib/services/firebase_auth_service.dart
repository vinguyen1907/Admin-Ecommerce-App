import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      // final credential =
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw FirebaseAuthException(
            code: 'user-not-found', message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
