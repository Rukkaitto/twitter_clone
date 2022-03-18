import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/dependency_injector.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/domain/repositories/repository.dart';
import 'package:twitter_clone/features/user/ui/cubit/user_cubit.dart';
import 'package:twitter_clone/features/user/ui/widgets/profile_widget.dart';

class UserView extends StatelessWidget {
  static String routeName = '/user';

  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userUid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: BlocProvider<UserCubit>(
        create: (context) => getIt<UserCubit>()..getUser(userUid),
        child: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is UserLoading) {
              return buildLoading();
            } else if (state is UserLoaded) {
              return buildLoaded(state.user);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildLoaded(UserEntity user) {
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(user.username),
            actions: [
              buildFollowIconButton(context, user),
            ],
          ),
          body: ProfileView(user: user),
        );
      },
    );
  }

  Widget buildFollowIconButton(BuildContext context, UserEntity user) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    if (user.uid == currentUser.uid) return Container();
    if (user.followers?.contains(currentUser.uid) ?? false) {
      return buildAppBarTextButton(
        'Unfollow',
        onPressed: () => handleUnfollow(context, user.uid),
      );
    } else {
      return buildAppBarTextButton(
        'Follow',
        onPressed: () => handleFollow(context, user.uid),
      );
    }
  }

  Widget buildAppBarTextButton(
    String text, {
    required VoidCallback onPressed,
  }) {
    return IconButton(
      constraints: const BoxConstraints.expand(width: 80),
      icon: Text(
        text,
        textAlign: TextAlign.center,
      ),
      onPressed: onPressed,
    );
  }

  void handleFollow(BuildContext context, String userUid) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    getIt<UserRepository>().addFollower(userUid, currentUser.uid);
    context.read<UserCubit>().getUser(userUid);
  }

  void handleUnfollow(BuildContext context, String userUid) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    getIt<UserRepository>().removeFollower(userUid, currentUser.uid);
    context.read<UserCubit>().getUser(userUid);
  }
}
