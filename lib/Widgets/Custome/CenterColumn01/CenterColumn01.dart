import 'package:flutter/cupertino.dart';

class CenterColumn01 extends StatelessWidget {
  final List<Widget> children;

  const CenterColumn01({super.key, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: children,
        ),
      ),
    );
  }
}
