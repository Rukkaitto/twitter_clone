import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twitter_clone/features/user/data/exceptions/user_not_found_exception.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/domain/repositories/repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit({required this.repository}) : super(UserInitial());

  void getUser(String id) async {
    emit(UserLoading());
    try {
      final user = await repository.getUser(id);
      emit(UserLoaded(user: user));
    } on UserNotFoundException {
      emit(const UserError(message: 'User not found.'));
    }
  }
}
