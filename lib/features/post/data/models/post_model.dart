import 'package:twitter_clone/features/post/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required String content,
    required String authorUid,
  }) : super(
          content: content,
          authorUid: authorUid,
        );

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      content: json['content'] as String,
      authorUid: json['authorUid'] as String,
    );
  }

  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      content: entity.content,
      authorUid: entity.authorUid,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'authorUid': authorUid,
    };
  }
}
