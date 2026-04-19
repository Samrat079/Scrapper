import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:scrapper/Models/Address/Address02.dart';
import 'package:scrapper/Models/Orders/Order01.dart';
import 'package:scrapper/Services/AppUserServices/AppUserServices01.dart';

class Order01Service extends ValueNotifier<Order01?> {
  /// Needs singleton as only one curr order
  /// can exist on one application
  static final Order01Service _instance = Order01Service._internal();

  Order01Service._internal() : super(null);

  factory Order01Service() => _instance;

  /// For loading state
  bool isLoading = false;

  StreamSubscription<QuerySnapshot<Order01>>? _orderSub;

  CollectionReference<Order01> get _ref => FirebaseFirestore.instance
      .collection('order01')
      .withConverter<Order01>(
        fromFirestore: Order01.fromFirestore,
        toFirestore: (model, _) => model.toJson(),
      );

  /// init
  void init() {
    final uid = AppUserServices01().current.uid;

    /// loading state needs notificator to work
    if (uid == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    /// Cancels any prev subscription
    _orderSub?.cancel();

    _orderSub = _ref
        .where('customer.uid', isEqualTo: uid)
        .where(
          'status',
          whereIn: [Order01Status.requested.name, Order01Status.assigned.name],
        )
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isEmpty) {
            value = null;
          } else {
            value = snapshot.docs.first.data();
          }
          isLoading = false;
          notifyListeners();
        });
  }

  /// dispose 2 ///
  /// Conventional dispose didn't work
  /// would continues to listener after logout
  /// moved on to reset removes everything and
  /// notifies listeners
  void reset() {
    _orderSub?.cancel();
    _orderSub = null;
    value = null;
    isLoading = false;
    notifyListeners();
  }

  Future<void> placeOrder(double price, Address02 address) async {
    final customer = AppUserServices01().current.customer01!;
    final doc = _ref.doc();

    final order = Order01(
      uid: doc.id,
      price: price,
      address: address,
      customer: customer,
      createdAt: Timestamp.now(),
    );

    await doc.set(order);
    value = order;
  }

  Future<void> cancelCurrOrder() async {
    final id = value?.uid;
    value = null;
    await _ref.doc(id).update({'status': Order01Status.cancelled.name});
  }
}
