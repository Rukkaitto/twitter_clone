import 'package:flutter/material.dart';
import 'package:twitter_clone/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Twitter Clone',
      home: HomePage(),
    );
  }
}
