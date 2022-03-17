import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/features/post/data/models/post_model.dart';
import 'package:twitter_clone/features/user/data/models/user_model.dart';

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
    final user = await firestore.doc('users/$userUid').get();
    if (user.data() == null) return [];
    final userModel = UserModel.fromJson(user.data()!);

    final postDocuments = await firestore.collection(collection).get();
    final postModels = postDocuments.docs
        .map((doc) => PostModel.fromJson(doc.data()))
        .toList();

    final ownPosts = postModels.where((post) => post.authorUid == userUid);
    final followingPosts = postModels.where(
      (post) => userModel.following?.contains(post.authorUid) ?? false,
    );

    final posts = [
      ...ownPosts,
      ...followingPosts,
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return posts;
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
