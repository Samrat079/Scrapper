import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrapper/Models/UserModel/UserModel01.dart';
import 'package:scrapper/Services/UserServices01/UserServices01.dart';

class AuthServices {
  static final AuthServices _instance = AuthServices._internal();

  AuthServices._internal();

  factory AuthServices() {
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  Stream<User?> get authChange => _auth.authStateChanges();

  /// Phone number signup, this returns a confirmation
  /// it needes to be confirmed by the otp
  Future<void> sendOtp(String number) async {
    final Completer<void> completer = Completer();

    await _auth.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential cred) async {
        await _auth.signInWithCredential(cred);
        completer.complete();
      },
      verificationFailed: (FirebaseAuthException e) {
        completer.completeError(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        completer.complete();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );

    return completer.future;
  }

  /// This is the one which confirms the otp
  Future<User?> verifyOtp(String otp) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    return await _auth.signInWithCredential(credential).then((e) {
      final user = UserModel01.fromJson({
        'uid': e.user!.uid,
        'displayName': e.user!.displayName,
        'phoneNumber': e.user!.phoneNumber,
        'email': e.user!.email,
      });
      UserServices01().createUser(user);
      return e.user;
    });
  }

  Future<void> logout() async => await _auth.signOut();

  /// This returns a optional user
  User? get currUser => _auth.currentUser;

  /// This returns a confirm user but will throw if not logged in
  // User get user {
  //   final user = _auth.currentUser;
  //   if (user == null) {
  //     throw Exception("User not logged in");
  //   }
  //   return user;
  // }
}
