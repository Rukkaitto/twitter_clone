import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/features/auth/ui/views/login_view.dart';

class HomePage extends StatelessWidget {
  static String routeName = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Twitter Clone'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: handleLogout,
                ),
              ],
            ),
            body: Center(
              child: Text('Welcome ${snapshot.data?.displayName}!'),
            ),
          );
        } else {
          return LoginView();
        }
      },
    );
  }

  void handleLogout() {
    FirebaseAuth.instance.signOut();
  }
}
