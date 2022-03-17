import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUser(String id);

  Future<void> addUser(UserEntity user);
}
