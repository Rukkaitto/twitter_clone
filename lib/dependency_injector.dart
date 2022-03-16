import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:twitter_clone/features/auth/data/datasources/remote_datasource.dart';
import 'package:twitter_clone/features/auth/data/repositories/repository_impl.dart';
import 'package:twitter_clone/features/auth/domain/repositories/repository.dart';
import 'package:twitter_clone/features/auth/ui/cubit/user_cubit.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDatasource: getIt<UserRemoteDatasource>(),
    ),
  );

  getIt.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDatasourceImpl(
      firestore: FirebaseFirestore.instance,
    ),
  );

  getIt.registerFactory<UserCubit>(
    () => UserCubit(
      repository: getIt<UserRepository>(),
    ),
  );
}
