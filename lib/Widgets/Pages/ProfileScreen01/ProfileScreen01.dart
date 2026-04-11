import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrapper/Models/UserModel/UserModel01.dart';
import 'package:scrapper/Services/Auth/AuthServices.dart';
import 'package:scrapper/Services/UserServices01/UserServices01.dart';
import 'package:scrapper/Widgets/Custome/CenterColumn01/CenterColumn01.dart';

class ProfileScreen01 extends StatelessWidget {
  const ProfileScreen01({super.key});

  @override
  Widget build(BuildContext context) {
    final User currUser = AuthServices().currUser!;

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: UserServices01().getUserById(currUser.uid),
        builder: (context, snapshot) {
          return CenterColumn01(
            children: [
              Text('This is the profile page'),
              Text(snapshot.data?.phoneNumber ?? 'This value is` null'),
              ElevatedButton(
                onPressed: () {
                  AuthServices().logout();
                  Navigator.pop(context);
                },
                child: Text('Logout'),
              ),
            ],
          );
        }
      ),
    );
  }
}
