import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twitter_clone/features/post/domain/entities/post_entity.dart';
import 'package:twitter_clone/features/post/domain/repositories/repository.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/domain/repositories/repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository userRepository;
  final PostRepository postRepository;

  ProfileCubit({
    required this.userRepository,
    required this.postRepository,
  }) : super(ProfileInitial());

  void getProfile(String userUid) async {
    if (state is ProfileInitial) {
      emit(ProfileLoading());
    }
    try {
      final user = await userRepository.getUser(userUid);
      final posts = await postRepository.getPostsFromUser(userUid);
      emit(ProfileLoaded(user: user, posts: posts));
    } on Exception {
      emit(const ProfileError(
          message: 'There was an error loading your profile.'));
    }
  }
}
