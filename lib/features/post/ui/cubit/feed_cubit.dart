import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/domain/repositories/repository.dart';
import 'package:twitter_clone/features/post/domain/entities/post_entity.dart';
import 'package:twitter_clone/features/post/domain/repositories/repository.dart';

part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  final PostRepository postRepository;
  final UserRepository userRepository;

  FeedCubit({
    required this.postRepository,
    required this.userRepository,
  }) : super(FeedInitial());

  void getFeed(String userUid) async {
    if (state is FeedInitial) {
      emit(FeedLoading());
    }
    try {
      final posts = await postRepository.getFeed(userUid);
      final List<PostWithUser> postsWithUsers = [];
      for (final post in posts) {
        final user = await userRepository.getUser(post.authorUid);
        postsWithUsers.add(PostWithUser(
          post: post,
          user: user,
        ));
      }
      emit(FeedLoaded(posts: postsWithUsers));
    } on Exception {
      emit(const FeedError(message: 'There was an error loading your feed.'));
    }
  }
}
