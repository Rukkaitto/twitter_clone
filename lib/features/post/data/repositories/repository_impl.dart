import 'package:twitter_clone/features/post/data/datasources/remote_datasource.dart';
import 'package:twitter_clone/features/post/data/models/post_model.dart';
import 'package:twitter_clone/features/post/domain/entities/post_entity.dart';
import 'package:twitter_clone/features/post/domain/repositories/repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDatasource remoteDatasource;

  PostRepositoryImpl({required this.remoteDatasource});

  @override
  Future<void> addPost(PostEntity post) {
    return remoteDatasource.addPost(PostModel.fromEntity(post));
  }

  @override
  Future<List<PostEntity>> getPosts() {
    return remoteDatasource.getPosts();
  }

  @override
  Future<List<PostEntity>> getFeed(String userUid) {
    return remoteDatasource.getFeed(userUid);
  }
}
