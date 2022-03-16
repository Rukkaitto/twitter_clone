import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/app.dart';
import 'firebase_options.dart';
import 'package:twitter_clone/dependency_injector.dart' as dependency_injector;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  dependency_injector.setup();
  runApp(const App());
}
