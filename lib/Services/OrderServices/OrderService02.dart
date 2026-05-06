import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrapper/Models/Customer/Customer01.dart';

import '../../Models/Address/Address02.dart';
import '../../Models/Orders/Order01.dart';
import '../AppUserServices/AppUserService02.dart';
import '../AppUserServices/AppUserServices01.dart';
import '../OSRMServices/OSRMService02.dart';

// class OrderService02 extends ChangeNotifier {
//   final AppUserServices02 appUser;
//   final OSRMService02 osrm;
//   final FirebaseFirestore firestore;
//
//   OrderService02({
//     required this.appUser,
//     required this.osrm,
//     required this.firestore,
//   });
//
//   final rand = Random();
//
//   Order01? _current;
//
//   Order01? get current => _current;
//
//   StreamSubscription<QuerySnapshot<Order01>>? _orderSub;
//
//   CollectionReference<Order01> get _ref => firestore
//       .collection('order01')
//       .withConverter<Order01>(
//         fromFirestore: Order01.fromFirestore,
//         toFirestore: (model, _) => model.toJson(),
//       );
//
//   void init() {
//     final uid = appUser.current.uid;
//
//     _orderSub?.cancel();
//
//     _orderSub = _ref
//         .where('customer.uid', isEqualTo: uid)
//         .where(
//           'status',
//           whereIn: [Order01Status.assigned.name, Order01Status.requested.name],
//         )
//         .snapshots()
//         .listen((snapshot) async {
//           if (snapshot.docs.isEmpty) {
//             _setCurrent(null);
//             return;
//           }
//           await _updateValue(snapshot);
//         });
//   }
//
//   Future<void> _updateValue(QuerySnapshot<Order01> snapshot) async {
//     final curr = snapshot.docs.first.data();
//
//     if (curr.sanitarian == null || curr.sanitarian?.latLng == null) {
//       _setCurrent(curr);
//       return;
//     }
//
//     curr.routesRes = await osrm.getRouteGeoJson(
//       curr.sanitarian!.latLng!,
//       curr.destination,
//     );
//
//     _setCurrent(curr);
//   }
//
//   void _setCurrent(Order01? order) {
//     _current = order;
//     notifyListeners();
//   }
//
//   void stop() {
//     _orderSub?.cancel();
//     _orderSub = null;
//     _setCurrent(null);
//   }
//
//   Future<void> placeOrder(double price, Address02 address) async {
//     final customer = appUser.current.customer01!;
//     final doc = _ref.doc();
//
//     final order = Order01(
//       uid: doc.id,
//       price: price,
//       address: address,
//       customer: customer,
//       createdAt: Timestamp.now(),
//       otp: rand.nextInt(900000) + 100000,
//     );
//
//     await doc.set(order);
//     _setCurrent(order);
//   }
//
//   Future<void> updatePrice(double price) async {
//     if (_current == null) return;
//     if (price < 10) return;
//
//     await _ref.doc(_current!.uid).update({"price": price});
//     _current!.price = price;
//     notifyListeners();
//   }
//
//   Future<void> cancelCurrOrder() async {
//     final id = _current?.uid;
//     _setCurrent(null);
//
//     if (id != null) {
//       await _ref.doc(id).update({'status': Order01Status.cancelled.name});
//     }
//   }
//
//   @override
//   void dispose() {
//     _orderSub?.cancel();
//     super.dispose();
//   }
// }

/// New iteration
class OrderService02 extends ChangeNotifier {
  final OSRMService02 osrm;
  final FirebaseFirestore firestore;
  final AppUserServices02 appUserService;

  OrderService02({
    required this.osrm,
    required this.firestore,
    required this.appUserService,
  });

  final rand = Random();
  Customer01? _customer;

  Order01? _current;

  Order01? get current => _current;
  StreamSubscription<DocumentSnapshot<Order01>>? _orderSub;

  CollectionReference<Order01> get _ref => firestore
      .collection('order01')
      .withConverter<Order01>(
        fromFirestore: Order01.fromFirestore,
        toFirestore: (model, _) => model.toJson(),
      );

  void init(String orderId) {
    _orderSub?.cancel();

    _orderSub = _ref.doc(orderId).snapshots().listen((doc) async {
      if (!doc.exists) return;

      final data = doc.data();
      if (data == null) return;

      _current = data;
      notifyListeners();
      await _updateValue(data);
    });
  }

  // Future<void> _updateValue(QuerySnapshot<Order01> snapshot) async {
  //   final curr = snapshot.docs.first.data();
  //
  //   if (curr.sanitarian == null || curr.sanitarian?.latLng == null) {
  //     _setCurrent(curr);
  //     return;
  //   }
  //
  //   curr.routesRes = await osrm.getRouteGeoJson(
  //     curr.sanitarian!.latLng!,
  //     curr.destination,
  //   );
  //
  //   _setCurrent(curr);
  // }

  void setCustomer(Customer01? customer) {
    _customer = customer;
  }

  Future<void> _updateValue(Order01 doc) async {
    if (doc.sanitarian == null || doc.sanitarian?.latLng == null) {
      _setCurrent(doc);
      return;
    }

    doc.routesRes = await osrm.getRouteGeoJson(
      doc.sanitarian!.latLng!,
      doc.destination,
    );

    _setCurrent(doc);
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
    final customer = _customer;
    if (customer == null) return;

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
    if (price < 10) return;

    await _ref.doc(_current!.uid).update({"price": price});
    _current!.price = price;
    notifyListeners();
  }

  Future<void> cancelCurrOrder() async {
    final id = _current?.uid;
    if (id != null) {
      await _ref.doc(id).update({'status': Order01Status.cancelled.name});
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _orderSub?.cancel();
    super.dispose();
  }
}
