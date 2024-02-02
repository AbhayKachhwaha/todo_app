import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => googleSignIn(),
          child: const Text("Login"),
        ),
      ),
    );
  }

  void googleSignIn() async {
    GoogleSignInAccount? user = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? auth = await user?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: auth?.accessToken,
      idToken: auth?.idToken,
    );

    // UserCredential userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
