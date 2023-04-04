import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/notes_provider.dart';
import 'package:frontend/screens/notes_homepage.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/register.dart';
import 'package:frontend/services/api_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider<NotesProvider>(
          create: (_) => NotesProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'MyApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Builder(
          builder: (context) {
            final auth = Provider.of<AuthProvider>(context);
            return auth.isAuthenticated
                ? MultiProvider(
                    providers: [
                      Provider.value(value: auth),
                      Consumer<AuthProvider>(
                        builder: (ctx, auth, _) => ChangeNotifierProvider.value(
                          value: NotesProvider(),
                          child: const NotesHomePage(),
                        ),
                      ),
                    ],
                    child: const NotesHomePage(),
                  )
                : const LoginScreen();
          },
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
