import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Models/Address/Address02.dart';
import '../../Models/Orders/Order01.dart';
import '../AppUserServices/AppUserService02.dart';
import '../AppUserServices/AppUserServices01.dart';
import '../OSRMServices/OSRMService02.dart';

class OrderService02 extends ChangeNotifier {
  final AppUserServices02 appUser;
  final OSRMService02 osrm;
  final FirebaseFirestore firestore;

  OrderService02({
    required this.appUser,
    required this.osrm,
    required this.firestore,
  });

  final rand = Random();

  Order01? _current;

  Order01? get current => _current;

  StreamSubscription<QuerySnapshot<Order01>>? _orderSub;

  CollectionReference<Order01> get _ref => firestore
      .collection('order01')
      .withConverter<Order01>(
        fromFirestore: Order01.fromFirestore,
        toFirestore: (model, _) => model.toJson(),
      );

  /// INIT (you decided to keep it 👍)
  void init() {
    final uid = appUser.current.uid;

    _orderSub?.cancel();

    _orderSub = _ref
        .where('customer.uid', isEqualTo: uid)
        .where(
          'status',
          whereIn: [Order01Status.assigned.name, Order01Status.requested.name],
        )
        .snapshots()
        .listen((snapshot) async {
          if (snapshot.docs.isEmpty) {
            _setCurrent(null);
            return;
          }
          await _updateValue(snapshot);
        });
  }

  Future<void> _updateValue(QuerySnapshot<Order01> snapshot) async {
    final curr = snapshot.docs.first.data();

    if (curr.sanitarian == null || curr.sanitarian?.latLng == null) {
      _setCurrent(curr);
      return;
    }

    curr.routesRes = await osrm.getRouteGeoJson(
      curr.sanitarian!.latLng!,
      curr.destination,
    );

    _setCurrent(curr);
  }

  void _setCurrent(Order01? order) {
    _current = order;
    notifyListeners();
  }

  void stop() {
    _orderSub?.cancel();
    _orderSub = null;
    _setCurrent(null);
  }

  Future<void> placeOrder(double price, Address02 address) async {
    final customer = appUser.current.customer01!;
    final doc = _ref.doc();

    final order = Order01(
      uid: doc.id,
      price: price,
      address: address,
      customer: customer,
      createdAt: Timestamp.now(),
      otp: rand.nextInt(900000) + 100000,
    );

    await doc.set(order);
    _setCurrent(order);
  }

  Future<void> updatePrice(double price) async {
    if (_current == null) return;

    await _ref.doc(_current!.uid).update({"price": price});
    _current!.price = price;
    notifyListeners();
  }

  Future<void> cancelCurrOrder() async {
    final id = _current?.uid;
    _setCurrent(null);

    if (id != null) {
      await _ref.doc(id).update({'status': Order01Status.cancelled.name});
    }
  }

  @override
  void dispose() {
    _orderSub?.cancel();
    super.dispose();
  }
}
