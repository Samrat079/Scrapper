import 'package:flutter/material.dart';
import 'package:scrapper/Services/OrderServices/Order01Service.dart';
import 'package:scrapper/Widgets/Pages/CurrOrderScreen/CurrOrderScreen01.dart';
import 'package:scrapper/Widgets/Pages/HomeScreen/HomeScreen01.dart';

class HomeScreen02 extends StatelessWidget {
  const HomeScreen02({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Order01Service(),
      builder: (context, order, _) {
        if (order == null) return HomeScreen01();
        return CurrOrderScreen01();
      },
    );
  }
}
