import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';
import 'providers/theme_provider.dart';
import 'ui/home_screen.dart';
import 'ui/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) => runApp(ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) return Text(snapshot.error.toString());

            if (!snapshot.hasData) return const LoginScreen();

            UserModel user = UserModel(
              uid: FirebaseAuth.instance.currentUser!.uid,
              name: FirebaseAuth.instance.currentUser!.displayName!,
              imageUrl: FirebaseAuth.instance.currentUser!.photoURL!,
              tasks: [],
            );

            return HomeScreen(
              user: user,
            );
          }),
    );
  }
}
