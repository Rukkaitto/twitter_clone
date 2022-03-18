import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/dependency_injector.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/ui/cubit/follows_cubit.dart';
import 'package:twitter_clone/features/user/ui/widgets/user_list_widget.dart';

class FollowsView extends StatelessWidget {
  static String routeName = '/follows';

  const FollowsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userUid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Follows'),
      ),
      body: BlocProvider<FollowsCubit>(
        create: (_) => getIt<FollowsCubit>()..getFollows(userUid),
        child: BlocBuilder<FollowsCubit, FollowsState>(
          builder: (context, state) {
            if (state is FollowsLoading) {
              return buildLoading();
            } else if (state is FollowsLoaded) {
              return buildLoaded(state.follows);
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

  Widget buildLoaded(List<UserEntity> follows) {
    if (follows.isEmpty) {
      return const Center(
        child: Text('This user has no follows.'),
      );
    }
    return UserListWidget(users: follows);
  }
}
