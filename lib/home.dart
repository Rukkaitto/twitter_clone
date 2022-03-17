import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/dependency_injector.dart';
import 'package:twitter_clone/features/post/ui/cubit/feed_cubit.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/ui/cubit/user_cubit.dart';
import 'package:twitter_clone/features/user/ui/views/login_view.dart';
import 'package:twitter_clone/features/post/ui/views/post_form_view.dart';
import 'package:twitter_clone/features/post/ui/views/posts_view.dart';
import 'package:twitter_clone/features/user/ui/views/profile_view.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabSelectedIndex = 0;
  late PageController _pageController;
  static const List<Widget> tabs = <Widget>[
    PostsView(),
    Center(child: Text('Search')),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.hasData) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<UserCubit>(
                create: (_) => getIt()..getUser(authSnapshot.data!.uid),
              ),
              BlocProvider<FeedCubit>(
                create: (_) => getIt()..getFeed(authSnapshot.data!.uid),
              ),
            ],
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
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: tabs,
      ),
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

  void _onTabChanged(int index) {
    setState(() {
      _tabSelectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _tabSelectedIndex = index;
    });
  }
}
