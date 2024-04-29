import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static Future<UserCredential?> registerUser(String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<UserCredential?> loginUser(String email, String password) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  static void logoutUser() async {
    FirebaseAuth.instance.signOut();
  }
}