import 'package:cached_network_image/cached_network_image.dart';
import 'package:duration/duration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Models/Orders/Order01.dart';
import '../../../../Services/OrderServices/Order01Service.dart';
import '../../../../theme/theme_extensions.dart';
import '../../../Custome/CenterColumn/CenterColumn04.dart';

class AcceptedBottomSheet01 extends StatelessWidget {
  final ScrollController controller;
  final Order01 order;

  const AcceptedBottomSheet01({
    super.key,
    required this.controller,
    required this.order,
  });

  @override
  Widget build(BuildContext context) => CenterColumn04(
    scrollController: controller,
    children: [
      /// Sanitarian info
      ListTile(
        leading: CachedNetworkImage(
          imageUrl: order.sanitarian!.photoUrl,
          imageBuilder: (context, provider) =>
              CircleAvatar(backgroundImage: provider),
          placeholder: (context, url) => Icon(Icons.person_outline),
          errorWidget: (context, url, error) => Icon(Icons.error_outline),
        ),
        title: Text(
          "${order.sanitarian!.displayName} is has accepted your order",
        ),
        subtitle: Text(
          "Reaching your destination in ${order.routesRes.duration.pretty()}",
        ),
      ),
      Divider(),

      /// Order details
      ListTile(
        leading: const Icon(Icons.house_outlined),
        title: Text(order.address.place.name!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.address.place.displayName!,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            Text(order.address.phoneNumber),
          ],
        ),
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
