import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:scrapper/Models/Address/Address02.dart';
import 'package:scrapper/Models/Orders/Order01.dart';
import 'package:scrapper/Services/AppUserServices/AppUserServices01.dart';
import 'package:scrapper/Services/OSRMServices/OSRMService01.dart';

class Order01Service extends ValueNotifier<Order01?> {
  /// Needs singleton as only one curr order
  /// can exist on one application
  static final Order01Service _instance = Order01Service._internal();

  Order01Service._internal() : super(null);

  factory Order01Service() => _instance;

  /// For loading state

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

    /// Cancels any prev subscription
    _orderSub?.cancel();

    _orderSub = _ref
        .where('customer.uid', isEqualTo: uid)
        .where(
          'status',
          whereIn: [Order01Status.assigned.name, Order01Status.requested.name],
        )
        .snapshots()
        .listen((snapshot) async {
          if (snapshot.docs.isEmpty) return value = null;
          await updateValue(snapshot);
        });
  }

  Future<void> updateValue(QuerySnapshot<Order01> snapshot) async {
    final curr = snapshot.docs.first.data();
    if (curr.sanitarian == null && curr.sanitarian?.latLng != null)  {
      value = curr;
      return;
    }
    curr.routesRes = await OSRMService01().getRouteGeoJson(curr.sanitarian!.latLng!, curr.destination);
    value = curr;
  }

  void stop() {
    _orderSub?.cancel();
    _orderSub = null;
    value = null;
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
