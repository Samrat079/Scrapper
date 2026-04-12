import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrapper/Models/Customer/Address/Address01.dart';

class Customer01 {
  final String uid, displayName, phoneNumber, email, photoUrl;
  final Timestamp createdAt;
  // final List<Address01> addresses;

  // final User auth;

  Customer01({
    required this.uid,
    required this.displayName,
    required this.phoneNumber,
    required this.email,
    required this.createdAt,
    required this.photoUrl,
    // required this.addresses,
    // required this.auth,
  });

  factory Customer01.fromJson(Map<String, dynamic> json) {
    return Customer01(
      uid: json['uid'],
      displayName: json['displayName'] ?? 'Username not added',
      phoneNumber: json['phoneNumber'] ?? 'Phone number not verified',
      email: json['email'] ?? 'Email not varified',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      photoUrl:
          json['photoUrl'] ??
          'https://placehold.co/256x256/darkgreen/white.png?text=test',
      // auth: json as User,
      // addresses:
      //     (json['addresses'] as List?)
      //         ?.map((i) => Address01.fromJson(i))
      //         .toList() ??
      //     [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'email': email,
      'createdAt': createdAt,
      'photoUrl': photoUrl,
      // 'auth': auth,
      // 'addresses': addresses,
    };
  }
}
