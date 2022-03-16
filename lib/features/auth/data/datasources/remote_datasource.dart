import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/features/auth/data/models/user_model.dart';

abstract class UserRemoteDatasource {
  Future<UserModel> getUser(String id);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final FirebaseFirestore firestore;

  UserRemoteDatasourceImpl({required this.firestore});

  @override
  Future<UserModel> getUser(String id) {
    return firestore.doc('users/$id').get().then((snapshot) {
      if (snapshot.data() == null) throw Exception('User $id not found.');
      return UserModel.fromJson(snapshot.data()!);
    });
  }
}
