import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/dependency_injector.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/domain/repositories/repository.dart';
import 'package:twitter_clone/features/user/ui/widgets/profile_widget.dart';

class UserView extends StatelessWidget {
  static String routeName = '/user';

  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as UserEntity;
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
        actions: [
          IconButton(
            onPressed: () {
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser == null) return;
              getIt<UserRepository>().addFollower(user.uid, currentUser.uid);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ProfileView(user: user),
    );
  }
}
