import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:scrapper/Models/Address/Address02.dart';
import 'package:scrapper/Models/Orders/Order01.dart';
import 'package:scrapper/Services/AppUserServices/AppUserServices01.dart';

class Order01Service {
  /// 🔒 Singleton
  static final Order01Service _instance = Order01Service._internal();

  Order01Service._internal();

  factory Order01Service() => _instance;

  final ValueNotifier<Order01?> runningOrder = ValueNotifier(null);

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
    if (uid == null) return;

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
            runningOrder.value = null;
          } else {
            runningOrder.value = snapshot.docs.first.data();
          }
        });
  }

  void dispose() {
    _orderSub?.cancel();
    runningOrder.value = null;
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
    runningOrder.value = order;
  }

  /// Canceled curr order then updated listeners
  Future<void> cancelCurrOrder() async {
    final id = runningOrder.value?.uid;
    if (id == null) return;

    await _ref.doc(id).update({'status': Order01Status.cancelled.name});

    runningOrder.value = null;
  }

  /// 🔄 Update status
  Future<void> statusById(String id, Order01Status status) {
    return _ref.doc(id).update({'status': status.name});
  }

  Stream<QuerySnapshot<Order01>> getAllOrders() => _ref.snapshots();

  Stream<QuerySnapshot<Order01>> getAllByStatus(Order01Status status) =>
      _ref.where('status', isEqualTo: status.name).snapshots();

  Stream<QuerySnapshot<Order01>> myOrder() {
    final uid = AppUserServices01().current.uid;

    return _ref
        .where('customer.uid', isEqualTo: uid)
        .where(
          'status',
          whereIn: [Order01Status.requested.name, Order01Status.assigned.name],
        )
        .snapshots();
  }
}
