import 'package:flutter/material.dart';
import 'package:twitter_clone/features/auth/ui/views/register_view.dart';
import 'package:twitter_clone/features/post/ui/views/post_form_view.dart';
import 'package:twitter_clone/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter Clone',
      initialRoute: HomePage.routeName,
      routes: {
        RegisterView.routeName: (context) => RegisterView(),
        PostFormView.routeName: (context) => PostFormView(),
      },
      home: const HomePage(),
    );
  }
}
