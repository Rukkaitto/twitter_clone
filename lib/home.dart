import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/dependency_injector.dart';
import 'package:twitter_clone/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/auth/ui/cubit/user_cubit.dart';
import 'package:twitter_clone/features/auth/ui/views/login_view.dart';
import 'package:twitter_clone/features/post/ui/views/post_form_view.dart';
import 'package:twitter_clone/features/post/ui/views/posts_view.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabSelectedIndex = 0;
  static const List<Widget> tabs = <Widget>[
    PostsView(),
    Center(child: Text('Search')),
    Center(child: Text('Profile')),
  ];

  void _onTabChanged(int index) {
    setState(() {
      _tabSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.hasData) {
          return BlocProvider<UserCubit>(
            create: (_) => getIt()..getUser(authSnapshot.data!.uid),
            child: BlocConsumer<UserCubit, UserState>(
              listener: (context, state) {
                if (state is UserError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is UserLoading) {
                  return buildLoading();
                } else if (state is UserLoaded) {
                  return buildLoaded(state.user);
                }
                return Container();
              },
            ),
          );
        } else {
          return LoginView();
        }
      },
    );
  }

  Widget buildLoaded(UserEntity user) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _tabSelectedIndex,
        onTap: _onTabChanged,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => handleFormNavigation(context),
        child: const Icon(Icons.edit),
      ),
      appBar: AppBar(
        title: const Text('Twitter Clone'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: handleLogout,
          ),
        ],
      ),
      body: tabs[_tabSelectedIndex],
    );
  }

  Widget buildLoading() {
    return Center(
      child: Builder(
        builder: (context) {
          if (Platform.isIOS) {
            return const CupertinoActivityIndicator();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void handleLogout() {
    FirebaseAuth.instance.signOut();
  }

  void handleFormNavigation(BuildContext context) {
    Navigator.of(context).pushNamed(PostFormView.routeName);
  }
}
