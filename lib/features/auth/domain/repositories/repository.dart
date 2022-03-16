import 'package:twitter_clone/features/auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUser(String id);
}
