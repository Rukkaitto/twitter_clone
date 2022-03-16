import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/dependency_injector.dart';
import 'package:twitter_clone/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/auth/ui/cubit/user_cubit.dart';
import 'package:twitter_clone/features/auth/ui/views/login_view.dart';

class HomePage extends StatelessWidget {
  static String routeName = '/';

  const HomePage({Key? key}) : super(key: key);

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
        onPressed: () {},
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
      body: Center(
        child: Text(
          'Welcome ${user.username}!',
        ),
      ),
    );
  }

  Widget buildLoading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void handleLogout() {
    FirebaseAuth.instance.signOut();
  }
}
