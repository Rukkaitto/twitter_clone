part of 'followers_cubit.dart';

abstract class FollowersState extends Equatable {
  const FollowersState();

  @override
  List<Object> get props => [];
}

class FollowersInitial extends FollowersState {}

class FollowersLoading extends FollowersState {}

class FollowersLoaded extends FollowersState {
  final List<UserEntity> followers;

  const FollowersLoaded({required this.followers});

  @override
  List<Object> get props => [followers];
}

class FollowersError extends FollowersState {
  final String message;

  const FollowersError({required this.message});

  @override
  List<Object> get props => [message];
}
