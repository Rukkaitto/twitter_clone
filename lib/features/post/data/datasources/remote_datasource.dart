import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/features/post/data/models/post_model.dart';

abstract class PostRemoteDatasource {
  Future<void> addPost(PostModel post);
  Future<List<PostModel>> getPosts();
  Future<List<PostModel>> getFeed(String userUid);
  Future<List<PostModel>> getPostsFromUser(String userUid);
}

class PostRemoteDatasourceImpl implements PostRemoteDatasource {
  static String collection = 'posts';

  final FirebaseFirestore firestore;

  PostRemoteDatasourceImpl({required this.firestore});

  @override
  Future<void> addPost(PostModel post) {
    return firestore.collection(collection).add(post.toJson());
  }

  @override
  Future<List<PostModel>> getPosts() {
    return firestore.collection(collection).get().then((snapshot) {
      final posts =
          snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
      return posts;
    });
  }

  @override
  Future<List<PostModel>> getFeed(String userUid) async {
    final posts = await firestore
        .collection(collection)
        .where('authorUid', isEqualTo: userUid)
        .get();
    return posts.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<PostModel>> getPostsFromUser(String userUid) async {
    final posts = await firestore
        .collection(collection)
        .where('authorUid', isEqualTo: userUid)
        .get();
    return posts.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
  }
}
