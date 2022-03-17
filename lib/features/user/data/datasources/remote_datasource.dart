import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:twitter_clone/features/user/data/exceptions/user_not_found_exception.dart';
import 'package:twitter_clone/features/user/data/models/user_model.dart';

abstract class UserRemoteDatasource {
  Future<UserModel> getUser(String id);
  Future<void> addUser(UserModel user);
  Future<String> uploadAvatar(String userUid, Uint8List image);
  Future<void> addFollower(String userUid, String followerUid);
  Future<List<UserModel>> searchUsers(String search);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  static String collection = 'users';

  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  UserRemoteDatasourceImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<UserModel> getUser(String id) {
    return firestore.doc('$collection/$id').get().then((snapshot) {
      if (snapshot.data() == null) throw UserNotFoundException();
      return UserModel.fromJson(snapshot.data()!);
    });
  }

  @override
  Future<void> addUser(UserModel user) {
    return firestore.doc('$collection/${user.uid}').set(user.toJson());
  }

  @override
  Future<String> uploadAvatar(String userUid, Uint8List image) async {
    final ref = storage.ref().child('$collection/$userUid/avatar.jpg');
    final result = await ref.putData(image);
    final url = await result.ref.getDownloadURL();
    await firestore.doc('$collection/$userUid').update({'avatarUrl': url});
    return url;
  }

  @override
  Future<void> addFollower(String userUid, String followerUid) async {
    await firestore.doc('$collection/$userUid').update({
      'followers': FieldValue.arrayUnion([followerUid])
    });
    await firestore.doc('$collection/$followerUid').update({
      'following': FieldValue.arrayUnion([userUid])
    });
  }

  @override
  Future<List<UserModel>> searchUsers(String search) async {
    final users = await firestore
        .collection(collection)
        .where('username', isGreaterThanOrEqualTo: search)
        .get();
    return users.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }
}
