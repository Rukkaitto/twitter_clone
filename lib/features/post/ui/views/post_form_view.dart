import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/dependency_injector.dart';
import 'package:twitter_clone/features/post/domain/entities/post_entity.dart';
import 'package:twitter_clone/features/post/domain/repositories/repository.dart';

class PostFormView extends StatelessWidget {
  PostFormView({Key? key}) : super(key: key);

  static String routeName = '/post/form';
  final _contentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a post'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _contentTextController,
            decoration: const InputDecoration(
              labelText: 'Content',
            ),
          ),
          ElevatedButton(
            onPressed: () => handleSubmit(context),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void handleSubmit(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final post = PostEntity(
      content: _contentTextController.text,
      authorUid: user.uid,
    );
    getIt<PostRepository>().addPost(post);
  }
}
