import 'package:flutter/material.dart';

import '../../../../Models/Orders/Order01.dart';
import '../../../../Services/OrderServices/Order01Service.dart';
import '../../../../theme/theme_extensions.dart';
import '../../../Custome/CardList01/CardList01.dart';
import '../../../Custome/CenterColumn/CenterColumn04.dart';

class SearchingBottomSheet01 extends StatelessWidget {
  final ScrollController controller;
  final Order01 order;
  final VoidCallback onIncrement, onDecrement, onCancel;

  const SearchingBottomSheet01({
    super.key,
    required this.controller,
    required this.order,
    required this.onIncrement,
    required this.onDecrement, required this.onCancel,
  });

  @override
  Widget build(BuildContext context) => SafeArea(
    child: CenterColumn04(
      padding: context.paddingLG,
      scrollController: controller,
      children: [
        Image.asset('assets/Search/search_01.png', height: 200),
        context.gapMD,
        const Text(
          'Looking for sanitarians in your area',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        context.gapMD,
        const Center(child: LinearProgressIndicator()),
        context.gapMD,

        /// Location Card
        CardList01(
          children: [
            ListTile(
              leading: const Icon(Icons.location_pin),
              title: Text(order.address.place.name!),
              subtitle: Text(
                order.address.place.displayName!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        context.gapMD,

        CardList01(
          children: [
            Text(
              "If it takes longer to find a sanitarial, consider adding a larger sum.",
              style: context.textTheme.bodySmall,
            ),
            context.gapMD,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(onPressed: onDecrement, child: Text("-10")),
                Text("Rs. ${order.price}", style: context.textTheme.bodyLarge),
                OutlinedButton(onPressed: onIncrement, child: Text("+10")),
              ],
            ),
          ],
        ),
        context.gapMD,

        /// Cancel btn
        ElevatedButton(
          onPressed: onCancel,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colorScheme.errorContainer,
            foregroundColor: context.colorScheme.onErrorContainer,
          ),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
