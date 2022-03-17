import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String content;
  final String authorUid;

  const PostEntity({
    required this.content,
    required this.authorUid,
  });

  @override
  List<Object?> get props => [content, authorUid];
}
