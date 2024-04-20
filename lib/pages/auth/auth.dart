import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_cards/pages/auth/login_or_register.dart';
import 'package:flash_cards/pages/home.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User logged in
          if (snapshot.hasData) {
            return const HomePage();
          }
          // User not logged in
          return const LoginOrRegisterPage();
        },
      ),
    );
  }
}
