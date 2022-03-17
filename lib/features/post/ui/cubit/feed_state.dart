part of 'feed_cubit.dart';

class PostWithUser {
  final PostEntity post;
  final UserEntity user;

  PostWithUser({
    required this.post,
    required this.user,
  });
}

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<PostWithUser> posts;

  const FeedLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class FeedError extends FeedState {
  final String message;

  const FeedError({required this.message});

  @override
  List<Object> get props => [message];
}
