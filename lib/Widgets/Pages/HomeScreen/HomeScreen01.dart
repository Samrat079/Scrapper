import 'package:flutter/material.dart';
import 'package:scrapper/Models/Address/Address02.dart';
import 'package:scrapper/Services/OrderServices/Order01Service.dart';
import 'package:scrapper/Widgets/Custome/Drawers/Drawer01.dart';
import 'package:scrapper/Widgets/Custome/RichText/RichText01.dart';
import 'package:scrapper/theme/theme_extensions.dart';

import '../../Custome/CenterColumn/CenterColumn04.dart';

class HomeScreen01 extends StatelessWidget {
  const HomeScreen01({super.key});

  @override
  Widget build(BuildContext context) {
    void placeOrder() async {
      final result = await Navigator.pushNamed(context, '/location01');
      if (result == null || result is! Map<String, dynamic>) return;
      final place = result['place'];
      final houseNo = result['houseNo'];
      final phoneNumber = result['phoneNumber'];
      final price = result['price'];
      final address = Address02(
        place: place,
        houseNo: houseNo,
        phoneNumber: phoneNumber,
      );
      Order01Service().placeOrder(price, address);
    }

    return Scaffold(
      appBar: AppBar(),
      body: CenterColumn04(
        centerVertically: true,
        children: [
          Image.asset('assets/Illustrations/home_01.png', height: 300),

          context.gapMD,

          RichText01(
            text1: 'Too tired to',
            text2: ' take the trash out? ',
            text3: 'We will do it for you!!!',
            highlight: context.colorScheme.primary,
          ),

          context.gapMD,

          ElevatedButton(onPressed: placeOrder, child: Text('Book now')),
        ],
      ),
      drawer: Drawer01(),
    );
  }
}
