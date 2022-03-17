import 'package:twitter_clone/features/post/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<void> addPost(PostEntity post);
  Future<List<PostEntity>> getPosts();
  Future<List<PostEntity>> getPostsFromUser(String userUid);
  Future<List<PostEntity>> getFeed(String userUid);
}
