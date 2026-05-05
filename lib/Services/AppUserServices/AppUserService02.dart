import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Models/Customer/Customer01.dart';
import '../../Models/AppUser/AppUser01.dart';

class AppUserServices02 extends ChangeNotifier {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AppUserServices02({required this.auth, required this.firestore});

  late final CollectionReference<Customer01> _users = firestore
      .collection('customers')
      .withConverter<Customer01>(
        fromFirestore: Customer01.fromFirestore,
        toFirestore: (Customer01 c, _) => c.toJson(),
      );

  String? _verificationId;

  User? _authUser;
  Customer01? _customer;

  StreamSubscription<User?>? _authSub;

  /// PUBLIC STATE
  AppUser01 get current => AppUser01(auth: _authUser, customer01: _customer);

  bool get isLoggedIn => _authUser != null && _customer != null;

  bool get isReady => current.exists;

  /// INIT
  Future<void> init() async {
    _authSub?.cancel();

    _authSub = auth.authStateChanges().listen((user) async {
      _authUser = user;

      if (user == null) {
        _customer = null;
        notifyListeners();
        return;
      }

      final doc = await _users.doc(user.uid).get();
      _customer = doc.exists ? doc.data() : null;

      notifyListeners();
    });
  }

  /// 📲 Send OTP
  Future<void> sendOtp(String number) async {
    final completer = Completer<void>();

    await auth.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (cred) async {
        await auth.signInWithCredential(cred);
        completer.complete();
      },
      verificationFailed: (e) => completer.completeError(e),
      codeSent: (verificationId, _) {
        _verificationId = verificationId;
        completer.complete();
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );

    return completer.future;
  }

  /// 🔐 Verify OTP
  Future<AppUser01> verifyOtp(String otp) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    final result = await auth.signInWithCredential(credential);
    final user = result.user!;

    _authUser = user;

    final doc = await _users.doc(user.uid).get();

    if (!doc.exists) {
      final newCustomer = Customer01.fromAuth(user);

      await _users.doc(user.uid).set(newCustomer, SetOptions(merge: true));

      _customer = newCustomer;
    } else {
      _customer = doc.data();
    }

    notifyListeners();
    return current;
  }

  /// 👤 Get user by ID
  Future<Customer01> getUserById(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.data()!;
  }

  /// ✏️ Update user
  Future<void> updateAppUser(String displayName) async {
    await _authUser?.updateDisplayName(displayName);
    await _authUser?.reload();

    _authUser = auth.currentUser;

    await _users.doc(current.uid).update({'displayName': displayName});

    _customer?.displayName = displayName;

    notifyListeners();
  }

  /// 🚪 Logout
  Future<void> logout() async {
    await auth.signOut();

    _authUser = null;
    _customer = null;

    notifyListeners();
  }

  /// ❌ Delete user
  Future<void> delete() async {
    await _users.doc(_authUser?.uid).delete();
    await _authUser?.delete();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
