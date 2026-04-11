import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrapper/Services/Auth/AuthServices.dart';

class Drawer01 extends StatelessWidget {
  const Drawer01({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Text('Profile'),
            onTap: () => Navigator.pushNamed(
              context,
              '/profile',
              arguments: AuthServices().currUser?.uid,
            ),
          ),
          ListTile(
            title: Text('Login'),
            onTap: () => Navigator.pushNamed(context, '/login'),
          ),
          ListTile(
            title: Text('Error'),
            onTap: () => Navigator.pushNamed(context, '/error'),
          ),
        ],
      ),
    );
  }
}
