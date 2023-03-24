import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/notes_homepage.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/register.dart';
import 'package:frontend/services/api_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(apiService: ApiService()),
      child: MaterialApp(
        title: 'MyApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AuthProvider>(
          builder: (ctx, auth, _) => auth.isAuthenticated
              ? const NotesHomePage()
              : const LoginScreen(),
        ),
        routes: {
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          RegisterScreen.routeName: (ctx) => const RegisterScreen(),
          NotesHomePage.routeName: (ctx) => const NotesHomePage(),
          // add other routes here if needed
        },
      ),
    );
  }
}
