import 'package:flutter/material.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/ui/views/user_view.dart';

class UserListWidget extends StatelessWidget {
  final List<UserEntity> users;

  const UserListWidget({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: GestureDetector(
            onTap: () => handleNavigationToUserView(context, user),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl!),
            ),
          ),
          title: Text('@${user.username}'),
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
