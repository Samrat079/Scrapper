import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrapper/Models/Address/Address02.dart';
import 'package:scrapper/Models/Orders/Order01.dart';
import 'package:scrapper/Services/AppUserServices/AppUserServices01.dart';

class Order01Service {
  CollectionReference<Order01> get _ref => FirebaseFirestore.instance
      .collection('order01')
      .withConverter<Order01>(
        fromFirestore: Order01.fromFirestore,
        toFirestore: (model, _) => model.toJson(),
      );

  Future<void> addOrder(Order01 order) => _ref.add(order);

  /// place Order
  Future<void> placeOrder(double price, Address02 address) async {
    final customer = AppUserServices01().current.customer01!;
    final order = Order01(
      price: price,
      address: address,
      customer: customer,
      createdAt: Timestamp.now(),
    );
    _ref.add(order);
  }

  Future<void> statusById(String id, Order01Status status) =>
      _ref.doc(id).update({'status': status});

  Stream<QuerySnapshot<Order01>> getAllOrders() => _ref.snapshots();
}
