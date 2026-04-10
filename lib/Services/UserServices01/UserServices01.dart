import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrapper/Models/UserModel/UserModel01.dart';

class UserServices01 {
  static final UserServices01 _instance = UserServices01._internal();

  UserServices01._internal();

  factory UserServices01() {
    return _instance;
  }

  final CollectionReference _users = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<void> createUser(UserModel01 user) async {
    return await _users
        .doc(user.uid)
        .set(user.toJson(), SetOptions(merge: true))
        .catchError((e) => print("Cant add user: $e"));
  }

  Future<void> testUser() async {
    return await _users
        .add({'hello': 'wporld'})
        .then((value) => print('added$value'))
        .catchError((e) => print('test failed: $e'));
  }

  Future<UserModel01> getUserById(String uid) async {
    return await _users
        .doc(uid)
        .get()
        .then((e) => UserModel01.fromJson(e.data() as Map<String, dynamic>))
        .catchError((e) => print('cant get doc:$e'));
  }
}
