import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/register.dart';
import 'package:frontend/screens/notes_homepage.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        )
            .then((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NotesHomePage()),
          );
        });
      } catch (error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: Text(error.toString()),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RegisterScreen.routeName);
                },
                child: const Text("Don't have an account? Register now!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
