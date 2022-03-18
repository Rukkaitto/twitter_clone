import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/util/debouncer.dart';
import 'package:twitter_clone/dependency_injector.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/ui/cubit/search_cubit.dart';
import 'package:twitter_clone/features/user/ui/widgets/user_list_widget.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController _searchTextController;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (context) => getIt<SearchCubit>(),
      child: Builder(builder: (context) {
        return Column(
          children: [
            TextField(
              controller: _searchTextController,
              onChanged: (input) => onSearchChanged(context, input),
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return buildLoading();
                } else if (state is SearchLoaded) {
                  return buildLoaded(state.users);
                }
                return Container();
              },
            ),
          ],
        );
      }),
    );
  }

  void onSearchChanged(BuildContext context, String input) {
    _debouncer.run(
      () => context.read<SearchCubit>().search(input),
    );
  }

  Widget buildLoaded(List<UserEntity> users) {
    return UserListWidget(users: users);
  }

  Widget buildLoading() => const Center(child: CircularProgressIndicator());
}
