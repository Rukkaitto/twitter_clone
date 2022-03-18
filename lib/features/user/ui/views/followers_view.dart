import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/dependency_injector.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/ui/cubit/followers_cubit.dart';
import 'package:twitter_clone/features/user/ui/widgets/user_list_widget.dart';

class FollowersView extends StatelessWidget {
  static String routeName = '/followers';

  const FollowersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userUid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
      ),
      body: BlocProvider<FollowersCubit>(
        create: (_) => getIt<FollowersCubit>()..getFollowers(userUid),
        child: BlocBuilder<FollowersCubit, FollowersState>(
          builder: (context, state) {
            if (state is FollowersLoading) {
              return buildLoading();
            } else if (state is FollowersLoaded) {
              return buildLoaded(state.followers);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildLoaded(List<UserEntity> followers) {
    if (followers.isEmpty) {
      return const Center(
        child: Text('This user has no followers.'),
      );
    }
    return UserListWidget(users: followers);
  }
}
