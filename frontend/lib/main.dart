import 'package:flutter/material.dart';
import 'package:frontend/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/pages/notes_homepage.dart';

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
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NotesHomePage(),
      ),
    );
  }
}
