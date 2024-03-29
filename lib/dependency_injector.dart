import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:twitter_clone/features/user/data/datasources/remote_datasource.dart';
import 'package:twitter_clone/features/user/data/repositories/repository_impl.dart';
import 'package:twitter_clone/features/user/domain/repositories/repository.dart';
import 'package:twitter_clone/features/user/ui/cubit/followers_cubit.dart';
import 'package:twitter_clone/features/user/ui/cubit/follows_cubit.dart';
import 'package:twitter_clone/features/user/ui/cubit/profile_cubit.dart';
import 'package:twitter_clone/features/user/ui/cubit/search_cubit.dart';
import 'package:twitter_clone/features/user/ui/cubit/user_cubit.dart';
import 'package:twitter_clone/features/post/data/datasources/remote_datasource.dart';
import 'package:twitter_clone/features/post/data/repositories/repository_impl.dart';
import 'package:twitter_clone/features/post/domain/repositories/repository.dart';
import 'package:twitter_clone/features/post/ui/cubit/feed_cubit.dart';

final getIt = GetIt.instance;

void setup() {
  // Users
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDatasource: getIt<UserRemoteDatasource>(),
    ),
  );

  getIt.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDatasourceImpl(
      firestore: FirebaseFirestore.instance,
      storage: FirebaseStorage.instance,
    ),
  );

  getIt.registerFactory<UserCubit>(
    () => UserCubit(
      repository: getIt<UserRepository>(),
    ),
  );

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      postRepository: getIt<PostRepository>(),
    ),
  );

  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(
      repository: getIt<UserRepository>(),
    ),
  );

  getIt.registerFactory<FollowersCubit>(
    () => FollowersCubit(
      repository: getIt<UserRepository>(),
    ),
  );

  getIt.registerFactory<FollowsCubit>(
    () => FollowsCubit(
      repository: getIt<UserRepository>(),
    ),
  );

  // Posts
  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      remoteDatasource: getIt<PostRemoteDatasource>(),
    ),
  );

  getIt.registerLazySingleton<PostRemoteDatasource>(
    () => PostRemoteDatasourceImpl(
      firestore: FirebaseFirestore.instance,
    ),
  );

  getIt.registerFactory<FeedCubit>(
    () => FeedCubit(
      postRepository: getIt<PostRepository>(),
      userRepository: getIt<UserRepository>(),
    ),
  );
}
