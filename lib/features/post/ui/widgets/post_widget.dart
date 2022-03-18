import 'package:flutter/material.dart';
import 'package:twitter_clone/features/post/domain/entities/post_entity.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/ui/views/user_view.dart';

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
      leading: buildAvatar(user),
      title: GestureDetector(
        onTap: () => handleNavigationToUserView(context, user),
        child: Text('@${user.username}'),
      ),
      subtitle: Text(post.content),
    );
  }

  Widget? buildAvatar(UserEntity user) {
    if (user.avatarUrl == null) return null;
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () => handleNavigationToUserView(context, user),
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.avatarUrl!),
          ),
        );
      },
    );
  }

  void handleNavigationToUserView(BuildContext context, UserEntity user) {
    Navigator.pushNamed(
      context,
      UserView.routeName,
      arguments: user.uid,
    );
  }
}
