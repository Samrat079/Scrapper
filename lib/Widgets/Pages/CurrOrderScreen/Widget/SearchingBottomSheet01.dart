import 'package:flutter/material.dart';

import '../../../../Models/Orders/Order01.dart';
import '../../../../Services/OrderServices/Order01Service.dart';
import '../../../../theme/theme_extensions.dart';
import '../../../Custome/CardList01/CardList01.dart';
import '../../../Custome/CenterColumn/CenterColumn04.dart';

class SearchingBottomSheet01 extends StatelessWidget {
  final ScrollController controller;
  final Order01 order;

  const SearchingBottomSheet01({
    super.key,
    required this.controller,
    required this.order,
  });

  @override
  Widget build(BuildContext context) => CenterColumn04(
    padding: context.paddingLG,
    scrollController: controller,
    children: [
      Image.asset('assets/Search/search_01.png', height: 200),
      context.gapMD,
      const Center(child: LinearProgressIndicator()),
      context.gapMD,
      const Text(
        'Looking for sanitarians in your area',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
      CardList01(
        children: [
          ListTile(
            leading: const Icon(Icons.location_pin),
            title: Text(order.address.place.name!),
            subtitle: Text(order.address.place.displayName!),
          ),
        ],
      ),
      context.gapMD,
      ElevatedButton(
        onPressed: () => Order01Service().cancelCurrOrder(),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.errorContainer,
          foregroundColor: context.colorScheme.onErrorContainer,
        ),
        child: const Text('Cancel'),
      ),
    ],
  );
}
