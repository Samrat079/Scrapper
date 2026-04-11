import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListTile02 extends StatelessWidget {
  final String leadingText, trailingText;

  const ListTile02({
    super.key,
    required this.leadingText,
    required this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(leadingText, textAlign: TextAlign.start),
          Spacer(),
          Text(
            trailingText,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
