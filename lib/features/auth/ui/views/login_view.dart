import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          TextButton(
            onPressed: handleLogin,
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () => handleRegister(context),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  void handleRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  void handleLogin() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('User not found');
      } else if (e.code == 'wrong-password') {
        print('Wrong password');
      }
    }
  }
}
