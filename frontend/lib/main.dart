import 'package:flutter/material.dart';
import 'package:frontend/providers/notes_provider.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/notes_homepage.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotesProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.isLoggedIn) {
      return const NotesHomePage();
    } else {
      return const LoginScreen();
    }
  }
}
