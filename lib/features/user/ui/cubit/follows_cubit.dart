import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/domain/repositories/repository.dart';

part 'follows_state.dart';

class FollowsCubit extends Cubit<FollowsState> {
  final UserRepository repository;

  FollowsCubit({required this.repository}) : super(FollowsInitial());

  void getFollows(String userUid) async {
    if (state is FollowsInitial) {
      emit(FollowsLoading());
    }
    try {
      final follows = await repository.getFollowing(userUid);
      emit(FollowsLoaded(follows: follows));
    } on Exception {
      emit(const FollowsError(
          message: 'There was an error loading the Follows.'));
    }
  }
}
