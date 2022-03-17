import 'dart:typed_data';

import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUser(String id);
  Future<List<UserEntity>> searchUsers(String search);
  Future<void> addUser(UserEntity user);
  Future<String> uploadAvatar(String userUid, Uint8List image);
  Future<void> addFollower(String userUid, String followerUid);
}
