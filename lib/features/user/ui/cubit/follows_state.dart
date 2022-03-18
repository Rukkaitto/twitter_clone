part of 'follows_cubit.dart';

abstract class FollowsState extends Equatable {
  const FollowsState();

  @override
  List<Object> get props => [];
}

class FollowsInitial extends FollowsState {}

class FollowsLoading extends FollowsState {}

class FollowsLoaded extends FollowsState {
  final List<UserEntity> follows;

  const FollowsLoaded({required this.follows});

  @override
  List<Object> get props => [follows];
}

class FollowsError extends FollowsState {
  final String message;

  const FollowsError({required this.message});

  @override
  List<Object> get props => [message];
}
