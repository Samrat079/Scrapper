import 'package:flutter/material.dart';
import 'package:scrapper/Models/UserModel/UserModel01.dart';
import 'package:scrapper/Services/Auth/AuthServices.dart';
import 'package:scrapper/Services/UserServices01/UserServices01.dart';
import 'package:scrapper/Widgets/Custome/CardColumn/CardColumn02.dart';
import 'package:scrapper/Widgets/Custome/CardList01/CardList01.dart';
import 'package:scrapper/Widgets/Custome/CenterColumn/CenterColumb02.dart';
import 'package:scrapper/Widgets/Custome/CenterColumn/ScrollColumn01.dart';
import 'package:scrapper/Widgets/Custome/FutureBuilder01/FutureBuilder01.dart';
import 'package:scrapper/Widgets/Pages/ProfileScreen01/Widgets/ListTile02.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileScreen01 extends StatelessWidget {
  final String uid;

  const ProfileScreen01({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder01(
        future: UserServices01().getUserById(uid),
        child: (context, data) {
          return ScrollColumn01(
            children: [

              /// User profile section
              Row(
                spacing: 12,
                children: [
                  CircleAvatar(
                    radius: 54,
                    backgroundImage: NetworkImage(data.photoUrl),
                  ),
                  Text(
                    data.displayName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              /// User data card
              CardList01(
                children: [
                  ListTile(
                    leading: Text('Phone', style: TextStyle(fontSize: 14)),
                    trailing: Text(
                      data.phoneNumber,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  ListTile(
                    leading: Text('Email', style: TextStyle(fontSize: 14)),
                    trailing: Text(data.email, style: TextStyle(fontSize: 14)),
                  ),
                  ListTile(
                    leading: Text(
                      'User since: ',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Text(
                      timeago.format(data.createdAt.toDate()),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),

              /// Profile options
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  AuthServices().logout();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.logout_outlined),
                label: Text('Logout'),
              ),
            ],
          );
        },
      ),
    );
  }
}
