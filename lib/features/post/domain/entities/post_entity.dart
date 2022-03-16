import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String content;

  const PostEntity({
    required this.content,
  });

  @override
  List<Object?> get props => [content];
}
