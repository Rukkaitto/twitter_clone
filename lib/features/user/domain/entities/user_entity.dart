import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String username;
  final String? avatarUrl;
  final List<String>? followers;
  final List<String>? following;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.username,
    this.avatarUrl,
    this.followers,
    this.following,
  });

  @override
  List<Object?> get props => [uid, email, username, avatarUrl];
}
