import 'package:twitter_clone/features/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String uid,
    required String email,
    required String username,
    String? avatarUrl,
    List<String>? followers,
    List<String>? following,
  }) : super(
          uid: uid,
          email: email,
          username: username,
          avatarUrl: avatarUrl,
          followers: followers,
          following: following,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      followers: json['followers'] as List<String>?,
      following: json['following'] as List<String>?,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      username: entity.username,
      avatarUrl: entity.avatarUrl,
      followers: entity.followers,
      following: entity.following,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'avatarUrl': avatarUrl,
      'followers': followers,
      'following': following,
    };
  }
}
