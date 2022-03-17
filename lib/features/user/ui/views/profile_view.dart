import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/dependency_injector.dart';
import 'package:twitter_clone/features/post/ui/widgets/post_widget.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/domain/repositories/repository.dart';
import 'package:twitter_clone/features/user/ui/cubit/profile_cubit.dart';
import 'package:twitter_clone/features/user/ui/cubit/user_cubit.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User is null');
    return BlocProvider<ProfileCubit>(
      create: (context) => getIt<ProfileCubit>()..getProfile(user.uid),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileLoaded) {
            return buildLoaded(state);
          }
          return Container();
        },
      ),
    );
  }

  Widget buildLoaded(ProfileLoaded profile) {
    return Column(
      children: [
        buildAvatar(profile.user),
        buildUsername(profile),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('${profile.posts.length} posts'),
            Text('${profile.user.followers?.length ?? 0} followers'),
            Text('${profile.user.following?.length ?? 0} follows'),
          ],
        ),
        buildPosts(profile),
      ],
    );
  }

  Widget buildPosts(ProfileLoaded profile) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: profile.posts.length,
      itemBuilder: (context, index) {
        final post = profile.posts[index];
        return PostWidget(user: profile.user, post: post);
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  Widget buildUsername(ProfileLoaded profile) =>
      Text('@${profile.user.username}');

  Widget buildAvatar(UserEntity user) {
    if (user.avatarUrl == null) {
      return Builder(
        builder: (context) {
          return InkWell(
            onTap: () async {
              final picker = ImagePicker();
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (image == null) return;
              final data = await image.readAsBytes();
              await getIt<UserRepository>().uploadAvatar(user.uid, data);
            },
            child: const CircleAvatar(
              radius: 50,
              child: Icon(Icons.add),
            ),
          );
        },
      );
    } else {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(user.avatarUrl!),
      );
    }
  }
}
