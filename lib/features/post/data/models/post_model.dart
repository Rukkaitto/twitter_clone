import 'package:twitter_clone/features/post/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({required String content}) : super(content: content);

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      content: json['content'] as String,
    );
  }

  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      content: entity.content,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}
