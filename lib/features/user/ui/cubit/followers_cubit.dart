import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/domain/repositories/repository.dart';

part 'followers_state.dart';

class FollowersCubit extends Cubit<FollowersState> {
  final UserRepository repository;

  FollowersCubit({required this.repository}) : super(FollowersInitial());

  void getFollowers(String userUid) async {
    if (state is FollowersInitial) {
      emit(FollowersLoading());
    }
    try {
      final followers = await repository.getFollowers(userUid);
      emit(FollowersLoaded(followers: followers));
    } on Exception {
      emit(const FollowersError(
          message: 'There was an error loading the followers.'));
    }
  }
}
