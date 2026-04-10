import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrapper/Services/Auth/AuthServices.dart';
import 'package:scrapper/Widgets/Custome/CenterColumn01/CenterColumn01.dart';

class ProfileScreen01 extends StatelessWidget {
  const ProfileScreen01({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currUser = AuthServices().currUser;
    return Scaffold(
      appBar: AppBar(),
      body: CenterColumn01(
        children: [
          Text('This is the profile page'),
          Text(currUser?.phoneNumber ?? 'This value is null'),
          ElevatedButton(
            onPressed: () => AuthServices().logout(),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
