import 'package:twitter_clone/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String email,
    required String username,
  }) : super(
          email: email,
          username: username,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String,
      username: json['username'] as String,
    );
  }
}
