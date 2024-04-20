import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final _firebase = FirebaseAuth.instance;

  Future<User?> registerUser (String email, String password) async {
    try {
      final _userCredentials = await _firebase.createUserWithEmailAndPassword(email: email, password: password);
      return _userCredentials.user;
    }
    catch (e) {
      print("Error while creating new user");
      return null;
    }
  }

  Future<User?> loginUser (String email, String password) async {
    try {
      final _userCredentials = await _firebase.signInWithEmailAndPassword(email: email, password: password);
      return _userCredentials.user;
    }
    catch (e) {
      print("Error while signing in");
      return null;
    }
  }

  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }
}