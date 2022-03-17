import 'package:twitter_clone/features/post/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required String content,
    required String authorUid,
    required int createdAt,
  }) : super(
          content: content,
          authorUid: authorUid,
          createdAt: createdAt,
        );

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      content: json['content'] as String,
      authorUid: json['authorUid'] as String,
      createdAt: json['createdAt'] as int,
    );
  }

  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      content: entity.content,
      authorUid: entity.authorUid,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'authorUid': authorUid,
      'createdAt': createdAt,
    };
  }
}
