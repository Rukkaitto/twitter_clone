import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/features/post/ui/cubit/feed_cubit.dart';
import 'package:twitter_clone/features/post/ui/widgets/post_widget.dart';

class PostsView extends StatelessWidget {
  const PostsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Container();
    return BlocConsumer<FeedCubit, FeedState>(
      listener: (context, state) {
        if (state is FeedError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is FeedLoading) {
          return buildLoading();
        } else if (state is FeedLoaded) {
          return buildLoaded(user.uid, state.posts);
        }
        return Container();
      },
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildLoaded(String userUid, List<PostWithUser> posts) {
    return Builder(
      builder: (context) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<FeedCubit>().getFeed(userUid);
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: posts.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final postWithUser = posts[index];
              return PostWidget(
                user: postWithUser.user,
                post: postWithUser.post,
              );
            },
          ),
        );
      },
    );
  }
}
