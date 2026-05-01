import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:scrapper/Widgets/Custome/CardList01/CardList01.dart';

import '../../../../Models/Orders/Order01.dart';
import '../../../../Services/OrderServices/Order01Service.dart';
import '../../../../theme/theme_extensions.dart';
import '../../../Custome/CenterColumn/CenterColumn04.dart';

class AcceptedBottomSheet01 extends StatelessWidget {
  final ScrollController controller;
  final Order01 order;
  final VoidCallback onCancel;

  const AcceptedBottomSheet01({
    super.key,
    required this.controller,
    required this.order, required this.onCancel,
  });

  @override
  Widget build(BuildContext context) => SafeArea(
    child: CenterColumn04(
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
            "Reaching your destination in ${order.routesRes.duration.pretty(maxUnits: 2, tersity: DurationTersity.minute)}",
          ),
        ),
        Divider(),
        context.gapMD,

        /// Otp
        ListTile(
          visualDensity: VisualDensity(vertical: 2),
          leading: Icon(Icons.lock),
          title: Text("Otp"),
          subtitle: Text(
            "Share this otp with your sanitarian at your door step.",
          ),
          trailing: Card(
            color: context.colorScheme.primaryContainer,
            child: Padding(
              padding: context.paddingMD,
              child: Text(
                order.otp.toString(),
                style: TextStyle(color: context.colorScheme.onPrimary),
              ),
            ),
          ),
        ),
        Divider(),
        context.gapMD,

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
          onPressed: onCancel,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colorScheme.error,
            foregroundColor: context.colorScheme.onError,
          ),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
