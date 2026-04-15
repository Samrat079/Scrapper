import 'dart:ffi';

import 'package:scrapper/Models/Address/Address02.dart';
import 'package:scrapper/Models/Customer/Customer01.dart';

class Order01 {
  Double price;
  Address02 address;
  Customer01 customer;
  String? provider;
  Order01Status status;

  Order01({
    required this.price,
    required this.address,
    required this.customer,
    required this.provider,
    required this.status,
  });
}

enum Order01Status { requested, assigned, cancelled, expired }
