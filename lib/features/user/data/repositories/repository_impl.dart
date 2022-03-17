import 'package:twitter_clone/features/user/data/datasources/remote_datasource.dart';
import 'package:twitter_clone/features/user/data/models/user_model.dart';
import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/user/domain/repositories/repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl({required this.remoteDatasource});

  @override
  Future<UserEntity> getUser(String id) {
    return remoteDatasource.getUser(id);
  }

  @override
  Future<void> addUser(UserEntity user) {
    return remoteDatasource.addUser(UserModel.fromEntity(user));
  }
}
