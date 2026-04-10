import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrapper/Widgets/Pages/LoginScreen01/AddNumber01.dart';
import 'package:scrapper/Widgets/Pages/LoginScreen01/AddOtp01.dart';

class LoginScreen01 extends StatelessWidget {
  const LoginScreen01({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = PageController(initialPage: 0);
    return Scaffold(
      appBar: AppBar(title: Text('Login page')),
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.vertical,
        children: [AddNumber01(controller: _controller,), AddOtp01()],
      ),
    );
  }
}
