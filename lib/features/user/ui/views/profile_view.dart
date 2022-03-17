import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/features/user/ui/cubit/user_cubit.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserLoaded) {
          return Column(
            children: [
              Text('@${state.user.username}'),
              Text(state.user.email),
            ],
          );
        }
        return Container();
      },
    );
  }
}
