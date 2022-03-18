import 'package:flutter/material.dart';
import 'package:twitter_clone/features/user/ui/views/followers_view.dart';
import 'package:twitter_clone/features/user/ui/views/follows_view.dart';
import 'package:twitter_clone/features/user/ui/views/register_view.dart';
import 'package:twitter_clone/features/post/ui/views/post_form_view.dart';
import 'package:twitter_clone/features/user/ui/views/user_view.dart';
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
        UserView.routeName: (context) => const UserView(),
        FollowersView.routeName: (context) => const FollowersView(),
        FollowsView.routeName: (context) => const FollowsView(),
      },
      home: const HomePage(),
    );
  }
}
