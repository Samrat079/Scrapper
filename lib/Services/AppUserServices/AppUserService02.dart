import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrapper/Services/OrderServices/OrderService02.dart';

import '../../Models/Customer/Customer01.dart';
import '../../Models/AppUser/AppUser01.dart';
import '../../Models/Orders/Order01.dart';

class AppUserServices02 extends ChangeNotifier {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AppUserServices02({required this.auth, required this.firestore}) {
    _authSub = auth.authStateChanges().listen(_handleAuthChanged);
  }

  String? _verificationId;
  User? _authUser;
  Customer01? _customer;

  /// late
  late OrderService02 _orderService;

  /// Subscriptions
  StreamSubscription<User?>? _authSub;
  StreamSubscription<QuerySnapshot>? _ordersSub;

  /// PUBLIC STATE
  CollectionReference<Customer01> get _users => firestore
      .collection('customers')
      .withConverter<Customer01>(
        fromFirestore: Customer01.fromFirestore,
        toFirestore: (Customer01 c, _) => c.toJson(),
      );

  CollectionReference<Order01> get _orders => firestore
      .collection("order01")
      .withConverter(
        fromFirestore: Order01.fromFirestore,
        toFirestore: (Order01 order, _) => order.toJson(),
      );

  AppUser01 get current => AppUser01(auth: _authUser, customer01: _customer);

  bool get isLoggedIn => _authUser != null && _customer != null;

  bool get isReady => current.exists;

  /// Auth state change
  Future<void> _handleAuthChanged(User? user) async {
    _authUser = user;

    /// This stops the order stuff
    await _ordersSub?.cancel();
    _ordersSub = null;
    _orderService.stop();

    if (user == null) {
      _customer = null;
      notifyListeners();
      return;
    }

    final doc = await _users.doc(user.uid).get();

    if (!doc.exists) {
      final newCustomer = Customer01.fromAuth(user);
      await _users.doc(user.uid).set(newCustomer, SetOptions(merge: true));
      _customer = newCustomer;
    } else {
      _customer = doc.data();
    }

    // 🟢 START order listener after user is ready
    _startOrderListener(user.uid);
    _orderService.setCustomer(_customer);

    notifyListeners();
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
      await _users.doc(user.uid).set(newCustomer);
      _customer = newCustomer;
    } else {
      _customer = doc.data();
    }

    notifyListeners();
    return current;
  }

  void _startOrderListener(String uid) {
    _ordersSub = _orders
        .where('customer.uid', isEqualTo: uid)
        .where(
          'status',
          whereIn: [Order01Status.assigned.name, Order01Status.requested.name],
        )
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isEmpty) return;

          final order = snapshot.docs.first.data();
          if (order.uid == null) return;
          _orderService.init(order.uid!);
        });
  }

  void setOrderService(OrderService02 service) {
    _orderService = service;
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
    _orderService.stop();

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
    _ordersSub?.cancel();
    super.dispose();
  }
}
