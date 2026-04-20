import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrapper/Widgets/Pages/LoginScreen/Widgets/EditProfileView01.dart';
import 'package:scrapper/Widgets/Pages/LoginScreen/Widgets/Welcome01.dart';
import 'package:scrapper/Widgets/Pages/LoginScreen/Widgets/Welcome02.dart';

import 'Widgets/AddNumber01.dart';
import 'Widgets/AddOtp01.dart';

class LoginScreen01 extends StatelessWidget {
  const LoginScreen01({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: 0);
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          Welcome01(controller: controller),
          Welcome02(controller: controller),
          AddNumber01(controller: controller),
          AddOtp01(controller: controller),
          EditProfileView01(controller: controller)
        ],
      ),
    );
  }
}
