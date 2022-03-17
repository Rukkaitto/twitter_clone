import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/util/debouncer.dart';
import 'package:twitter_clone/dependency_injector.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/ui/cubit/search_cubit.dart';
import 'package:twitter_clone/features/user/ui/views/user_view.dart';

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
                  return buildLoaded(context, state.users);
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

  Widget buildLoaded(BuildContext context, List<UserEntity> users) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: GestureDetector(
            onTap: () => handleNavigationToUserView(context, user),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl!),
            ),
          ),
          title: Text('@${user.username}'),
        );
      },
    );
  }

  Widget buildLoading() => const Center(child: CircularProgressIndicator());

  void handleNavigationToUserView(BuildContext context, UserEntity user) {
    Navigator.pushNamed(
      context,
      UserView.routeName,
      arguments: user,
    );
  }
}
