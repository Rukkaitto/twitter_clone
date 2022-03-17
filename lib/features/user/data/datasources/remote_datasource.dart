import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/features/user/data/exceptions/user_not_found_exception.dart';
import 'package:twitter_clone/features/user/data/models/user_model.dart';

abstract class UserRemoteDatasource {
  Future<UserModel> getUser(String id);

  Future<void> addUser(UserModel user);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  static String collection = 'users';

  final FirebaseFirestore firestore;

  UserRemoteDatasourceImpl({required this.firestore});

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
}
