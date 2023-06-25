import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/contact_provider.dart';
import 'package:frontend/providers/notes_provider.dart';
import 'package:frontend/providers/tag_provider.dart';
import 'package:frontend/providers/todos_provider.dart';
import 'package:frontend/screens/notes_homepage.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/register.dart';
import 'package:frontend/services/api_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthProvider authProvider = AuthProvider(apiService: ApiService());
  await authProvider.initAuthProvider();
  runApp(MyApp(authProvider: authProvider));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  const MyApp({Key? key, required this.authProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => authProvider,
        ),
        ChangeNotifierProvider<NotesProvider>(
          create: (_) => NotesProvider(),
        ),
        ChangeNotifierProvider<TagProvider>(
          create: (_) => TagProvider(),
        ),
        ChangeNotifierProvider<TodoProvider>(
          create: (_) => TodoProvider(),
        ),
        ChangeNotifierProvider<ContactProvider>(
          create: (_) => ContactProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'MyApp',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: auth.isAuthenticated
                ? const NotesHomePage()
                : const LoginScreen(),
            routes: {
              LoginScreen.routeName: (ctx) => const LoginScreen(),
              RegisterScreen.routeName: (ctx) => const RegisterScreen(),
              NotesHomePage.routeName: (ctx) => const NotesHomePage(),
            },
          );
        },
      ),
    );
  }
}
