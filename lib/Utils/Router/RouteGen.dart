import 'package:flutter/material.dart';
import 'package:scrapper/Models/Customer/Customer01.dart';
import 'package:scrapper/Services/Auth/AuthServices.dart';
import 'package:scrapper/Services/CustomerServices/Customer01Services.dart';
import 'package:scrapper/Widgets/Pages/HomeScreen/HomeScreen02.dart';

import '../../Widgets/Pages/AddressesScreen/AddressesScreen01.dart';
import '../../Widgets/Pages/ErrorScreen/ErrorScreen01.dart';
import '../../Widgets/Pages/HomeScreen/HomeScreen01.dart';
import '../../Widgets/Pages/LoginScreen/LoginScreen01.dart';
import '../../Widgets/Pages/ProfileScreen/ProfileScreen01.dart';

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
      // case '/':
      //   return router(HomeScreen01());
      case '/':
        return router(HomeScreen02());
      case '/login':
        return router(LoginScreen01());
      case '/error':
        return router(ErrorScreen01());
      case '/home02':
        return router(HomeScreen02());
    }

    /// Protected route
    if (!isLoggedIn) return router(LoginScreen01());

    switch (name) {
      case '/profile':
        return router(ProfileScreen01(customer: args as Customer01));
      case '/addresses':
        return router(AddressesScreen01(customer: args as Customer01));
    }

    return router(ErrorScreen01());
  }
}
