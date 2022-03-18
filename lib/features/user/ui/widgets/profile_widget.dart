import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/dependency_injector.dart';
import 'package:twitter_clone/features/post/domain/entities/post_entity.dart';
import 'package:twitter_clone/features/post/ui/widgets/post_widget.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/domain/repositories/repository.dart';
import 'package:twitter_clone/features/user/ui/cubit/profile_cubit.dart';

class ProfileView extends StatelessWidget {
  final UserEntity user;
  const ProfileView({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => getIt<ProfileCubit>()..getProfile(user.uid),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return buildLoading();
          } else if (state is ProfileLoaded) {
            return buildLoaded(state.posts);
          }
          return Container();
        },
      ),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildLoaded(List<PostEntity> posts) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          buildAvatar(user),
          buildUsername(user),
          buildNumbers(user, posts),
          Expanded(
            child: buildPosts(posts),
          ),
        ],
      ),
    );
  }

  Widget buildNumbers(UserEntity user, List<PostEntity> posts) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('${posts.length} posts'),
          Text('${user.followers?.length ?? 0} followers'),
          Text('${user.following?.length ?? 0} follows'),
        ],
      ),
    );
  }

  Widget buildPosts(List<PostEntity> posts) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostWidget(user: user, post: post);
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  Widget buildUsername(UserEntity user) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final showFollowsYou = user.following?.contains(currentUser?.uid) ?? false;

    return Builder(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '@${user.username}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showFollowsYou)
            Text(
              'Follows you',
              style: Theme.of(context).textTheme.caption,
            ),
        ],
      );
    });
  }

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
