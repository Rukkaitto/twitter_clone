import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String content;
  final String authorUid;
  final int createdAt;

  const PostEntity({
    required this.content,
    required this.authorUid,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [content, authorUid, createdAt];
}
