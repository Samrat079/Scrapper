import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../theme/theme_extensions.dart';
import '../../../Custome/CenterColumn/CenterColumn04.dart';
import '../../../Custome/RichText/RichText01.dart';

class Welcome02 extends StatelessWidget {
  final PageController _controller;
  const Welcome02({super.key, required PageController controller}) : _controller = controller;

  @override
  Widget build(BuildContext context) => CenterColumn04(
    centerVertically: true,
    padding: context.paddingXL,
    children: [
      Image.asset('assets/Illustrations/waste_02.png', height: 256),
      context.gapMD,

      RichText01(
        text1: 'Connect with helpers',
        text2: ' close to your location ',
        text3: 'instantly',
        highlight: context.colorScheme.primary,
      ),

      context.gapLG,

      ElevatedButton(
        onPressed: () => _controller.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          foregroundColor: context.colorScheme.onPrimary,
        ),
        child: Text('Next'),
      ),
      context.gapMD,
    ],
  );
}
