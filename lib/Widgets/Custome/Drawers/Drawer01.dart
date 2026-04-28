import 'package:flutter/material.dart';
import 'package:scrapper/Services/AppUserServices/AppUserServices01.dart';

class Drawer01 extends StatelessWidget {
  const Drawer01({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Profile'),
            onTap: () => Navigator.pushNamed(
              context,
              '/profile',
              arguments: AppUserServices01().current.customer01,
            ),
          ),
          // ListTile(
          //   title: Text('Login'),
          //   onTap: () => Navigator.pushNamed(context, '/login'),
          // ),
          // ListTile(
          //   leading: Icon(Icons.error_outline),
          //   title: Text('Error'),
          //   onTap: () => Navigator.pushNamed(context, '/error'),
          // ),
          ListTile(
            iconColor: Theme.of(context).colorScheme.error,
            textColor: Theme.of(context).colorScheme.error,
            leading: Icon(Icons.logout_outlined),
            title: Text('Logout'),
            onTap: () => AppUserServices01().logout().then(
              (_) => Navigator.pushNamed(context, '/login'),
            ),
          ),
        ],
      ),
    );
  }
}
