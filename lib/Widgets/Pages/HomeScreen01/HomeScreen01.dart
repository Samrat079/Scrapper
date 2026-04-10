import 'package:flutter/material.dart';
import 'package:scrapper/Widgets/Custome/CenterColumn01/CenterColumn01.dart';
import 'package:scrapper/Widgets/Custome/Drawers/Drawer01.dart';

class HomeScreen01 extends StatelessWidget {
  const HomeScreen01({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CenterColumn01(
        children: [Text('Home test'), Text('This is the second')],
      ),
      drawer: Drawer01(),
    );
  }
}
