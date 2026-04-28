import 'package:flutter/material.dart';
import 'package:scrapper/Models/Customer/Customer01.dart';
import 'package:scrapper/Services/AppUserServices/AppUserServices01.dart';
import 'package:scrapper/Services/OrderServices/Order01Service.dart';
import 'package:scrapper/Widgets/Pages/HomeScreen/HomeScreen02.dart';
import 'package:scrapper/Widgets/Pages/LocationForm/LocationForm01.dart';

import '../../Widgets/Pages/AddressesScreen/AddressesScreen01.dart';
import '../../Widgets/Pages/EditProfileScreen/EditProfileScreen01.dart';
import '../../Widgets/Pages/ErrorScreen/ErrorScreen01.dart';
import '../../Widgets/Pages/LoginScreen/LoginScreen01.dart';
import '../../Widgets/Pages/ProfileScreen/ProfileScreen01.dart';

class RouteGen {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final name = settings.name;
    final isLoggedIn = AppUserServices01().isLoggedIn;
    final currOrder = Order01Service().value != null;

    /// reduces boiler plate
    Route<dynamic> router<T>(Widget page) =>
        MaterialPageRoute<T>(builder: (_) => page);

    /// Unguarded routes
    switch (name) {
      case '/':
        return router(HomeScreen02());
      case '/login':
        return router(LoginScreen01());
      case '/error':
        return router(ErrorScreen01());
    }

    /// Protected route
    if (!isLoggedIn) return router(LoginScreen01());

    switch (name) {
      case '/location01':
        return router(LocationForm01());
      case '/edit_profile':
        return router(EditProfileScreen01());
      case '/profile':
        return router(ProfileScreen01());
      case '/addresses':
        return router(AddressesScreen01(customer: args as Customer01));
    }

    return router(ErrorScreen01());
  }
}
