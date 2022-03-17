import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/domain/repositories/repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final UserRepository repository;

  SearchCubit({required this.repository}) : super(SearchInitial());

  void search(String input) async {
    if (input == '') {
      emit(const SearchLoaded(users: []));
      return;
    }
    if (state is SearchInitial) {
      emit(SearchLoading());
    }
    try {
      final users = await repository.searchUsers(input);
      emit(SearchLoaded(users: users));
    } on Exception {
      emit(const SearchError(message: 'There was an error searching users.'));
    }
  }
}
