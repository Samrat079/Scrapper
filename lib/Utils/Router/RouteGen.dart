import 'package:flutter/material.dart';
import 'package:scrapper/Models/Customer/Customer01.dart';
import 'package:scrapper/Services/Auth/AuthServices.dart';
import 'package:scrapper/Widgets/Pages/AddressesScreen01/AddressesScreen01.dart';
import 'package:scrapper/Widgets/Pages/ErrorScreen01/ErrorScreen01.dart';
import 'package:scrapper/Widgets/Pages/LoginScreen01/LoginScreen01.dart';
import 'package:scrapper/Widgets/Pages/ProfileScreen01/ProfileScreen01.dart';

import '../../Widgets/Pages/HomeScreen01/HomeScreen01.dart';

class RouteGen {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final name = settings.name;
    final isLoggedIn = AuthServices().currUser != null;

    /// reduces boiler plate
    Route<dynamic> router(Widget page) =>
        MaterialPageRoute(builder: (_) => page);

    /// Unguarded routes
    switch (name) {
      case '/':
        return router(HomeScreen01());
      case '/login':
        return router(LoginScreen01());
      case '/error':
        return router(ErrorScreen01());
    }

    /// Protected route
    if (!isLoggedIn) return router(LoginScreen01());

    switch (name) {
      case '/profile':
        return router(ProfileScreen01(uid: args as String));
      case '/addresses':
        return router(AddressesScreen01(customer: args as Customer01));
    }

    return router(ErrorScreen01());
  }
}
