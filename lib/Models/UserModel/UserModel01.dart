class UserModel01 {
  String uid;
  String? displayName, phoneNumber, email;

  UserModel01({
    required this.uid,
    required this.displayName,
    required this.phoneNumber,
    required this.email,
  });

  factory UserModel01.fromJson(Map<String, dynamic> json) {
    return UserModel01(
      uid: json['uid'],
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }
}
