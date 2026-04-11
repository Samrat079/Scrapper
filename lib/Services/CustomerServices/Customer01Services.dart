import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrapper/Models/Customer/Customer01.dart';

class Customer01Services {
  static final Customer01Services _instance = Customer01Services._internal();

  Customer01Services._internal();

  factory Customer01Services() {
    return _instance;
  }

  final CollectionReference _users = FirebaseFirestore.instance.collection(
    'customers',
  );

  Future<void> createUser(Customer01 user) async {
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

  Future<Customer01> getUserById(String uid) async {
    return await _users
        .doc(uid)
        .get()
        .then((e) => Customer01.fromJson(e.data() as Map<String, dynamic>))
        .catchError((e) => print('cant get doc:$e'));
  }
}
