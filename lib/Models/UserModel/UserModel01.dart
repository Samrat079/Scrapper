import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel01 {
  final String uid, displayName, phoneNumber, email, photoUrl;
  final Timestamp createdAt;

  UserModel01({
    required this.uid,
    required this.displayName,
    required this.phoneNumber,
    required this.email,
    required this.createdAt,
    required this.photoUrl,
  });

  factory UserModel01.fromJson(Map<String, dynamic> json) {
    return UserModel01(
      uid: json['uid'],
      displayName: json['displayName'] ?? 'Username not added',
      phoneNumber: json['phoneNumber'] ?? 'Phone number not verified',
      email: json['email'] ?? 'Email not varified',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      photoUrl: json['photoUrl'] ?? 'https://placehold.co/256x256?text=Hello+World',
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
    };
  }
}
