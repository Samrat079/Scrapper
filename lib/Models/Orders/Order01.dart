import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:scrapper/Models/Address/Address02.dart';
import 'package:scrapper/Models/Customer/Customer01.dart';
import 'package:scrapper/Models/Sanitarian/Sanitarian01.dart';

import '../RouteResponse/RouteResponse.dart';

class Order01 {
  String? uid;
  double price;
  Address02 address;
  Customer01 customer;
  Sanitarian01? sanitarian;
  Order01Status status;
  Timestamp createdAt;
  RoutesResponse routesRes;

  Order01({
    this.uid,
    required this.price,
    required this.address,
    required this.customer,
    this.sanitarian,
    this.status = Order01Status.requested,
    required this.createdAt,

    RoutesResponse? routesRes,
  }) : routesRes = routesRes ?? RoutesResponse();

  factory Order01.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    if (data == null) {
      throw Exception("Order document is null");
    }

    final san = data['sanitarian'];

    return Order01(
      uid: snapshot.id,
      price: (data['price'] ?? 0).toDouble(),
      address: Address02.fromJson(data['address']),
      customer: Customer01.fromJson(data['customer']),
      status: Order01Status.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => Order01Status.requested,
      ),
      sanitarian: san is Map<String, dynamic>
          ? Sanitarian01.fromJson(san)
          : null,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'price': price,
    'address': address.toJson(),
    'customer': customer.toJson(),
    'createdAt': createdAt,
    'status': status.name,
    'sanitarian': sanitarian?.toJson(),
  };

  /// Simple getter for flatland for the destination
  LatLng get destination {
    final lat = double.parse(address.place.lat!);
    final lon = double.parse(address.place.lon!);
    return LatLng(lat, lon);
  }
}

enum Order01Status { requested, assigned, completed, cancelled, expired }
