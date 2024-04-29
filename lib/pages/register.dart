import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_cards/services/auth_services.dart';
import 'package:flash_cards/services/firestore_services.dart';
import 'package:flash_cards/widgets/button.dart';
import 'package:flash_cards/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flash_cards/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final firestore = FirestoreServices();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void registerUser() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        )
    );

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);

      displayMessageToUser("Passwords don't match!", context);
    }
    else {
      try {
        final email = emailController.text.trim().toLowerCase();
        final password = passwordController.text.trim();

        UserCredential? userCredential = await AuthServices.registerUser(email, password);

        createUserRecord(userCredential);

        if (context.mounted) {
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        displayMessageToUser(e.code, context);
      }
    }
  }

  Future<void> createUserRecord(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      FirestoreServices.addUserDocument(
          userCredential.user!.email!,
          usernameController.text.trim()
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      Icons.logo_dev,
                      size: 80,
                      color: Theme.of(context).colorScheme.inversePrimary
                  ),
                  const SizedBox(height: 25),
                  const Text(
                      "M I N I M A L",
                      style: TextStyle(fontSize: 20)
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                      hintText: "Username",
                      obscureText: false,
                      controller: usernameController
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                      hintText: "Email",
                      obscureText: false,
                      controller: emailController
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                      hintText: "Password",
                      obscureText: true,
                      controller: passwordController
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                      hintText: "Confirm Password",
                      obscureText: true,
                      controller: confirmPasswordController
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                      text: "Register",
                      onTap: registerUser
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                            " Log in Here",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            )
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ),
        )
    );
  }
}
