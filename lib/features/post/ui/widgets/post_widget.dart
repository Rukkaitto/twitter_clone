import 'package:flutter/material.dart';
import 'package:twitter_clone/features/post/domain/entities/post_entity.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';

class PostWidget extends StatelessWidget {
  final UserEntity user;
  final PostEntity post;

  const PostWidget({
    required this.user,
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: user.avatarUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl!),
            )
          : null,
      title: Text('@${user.username}'),
      subtitle: Text(post.content),
    );
  }
}
