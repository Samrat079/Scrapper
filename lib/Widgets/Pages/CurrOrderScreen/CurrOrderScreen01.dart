import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duration/duration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:scrapper/Models/Orders/Order01.dart';
import 'package:scrapper/Services/OrderServices/Order01Service.dart';
import 'package:scrapper/Widgets/Custome/CardList01/CardList01.dart';
import 'package:scrapper/Widgets/Custome/Drawers/Drawer01.dart';
import 'package:scrapper/Widgets/Pages/CurrOrderScreen/Widget/AcceptedBottomSheet01.dart';
import 'package:scrapper/Widgets/Pages/CurrOrderScreen/Widget/CurrOrderMap01.dart';
import 'package:scrapper/Widgets/Pages/CurrOrderScreen/Widget/SearchingBottomSheet01.dart';
import 'package:scrapper/Widgets/Pages/HomeScreen/HomeScreen01.dart';
import 'package:scrapper/theme/theme_extensions.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../Custome/CenterColumn/CenterColumn04.dart';

class CurrOrderScreen01 extends StatefulWidget {
  const CurrOrderScreen01({super.key});

  @override
  State<CurrOrderScreen01> createState() => _CurrOrderScreen01State();
}

class _CurrOrderScreen01State extends State<CurrOrderScreen01> {
  /// keys
  final GlobalKey<ScaffoldState> key = GlobalKey();
  final orderService = Order01Service();

  /// Controller
  final MapController mapController = MapController();
  final PanelController panelController = PanelController();

  /// This updates the camera
  void updateCamera() => orderService.addListener(() {
    final loc = orderService.value;
    if (loc == null) return;
    final List<LatLng> points = [loc.destination, loc.sanitarian!.latLng!];
    final bounds = LatLngBounds.fromPoints(points);
    mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(80)),
    );
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Order01?>(
      valueListenable: orderService,
      builder: (context, order, _) {
        if (order == null) {
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          key: key,
          extendBodyBehindAppBar: true,
          drawer: Drawer01(),

          /// The appbar as if a floating button
          /// opens the drawer but needs a scaffold key
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            leading: IconButton.filled(
              onPressed: () => key.currentState!.openDrawer(),
              icon: const Icon(Icons.menu_outlined),
              style: IconButton.styleFrom(
                backgroundColor: context.colorScheme.surface,
              ),
            ),
          ),

          body: SlidingUpPanel(
            controller: panelController,

            /// The map
            body: CurrOrderMap01(
              mapController: mapController,
              onMapReady: updateCamera,
              order: order,
            ),

            parallaxEnabled: true,
            parallaxOffset: 0.3,
            borderRadius: BorderRadius.vertical(top: context.radiusLG.topLeft),
            color: context.colorScheme.surface,
            panelBuilder: (ScrollController controller) {

              /// If there is not sanitarian
              /// Remember to put return statement in this
              if (order.status == Order01Status.assigned &&
                  order.sanitarian == null) {
                return SearchingBottomSheet01(
                  controller: controller,
                  order: order,
                );
              }

              /// If a sanitarian accepts the order
              /// this has return so wont crash
              return AcceptedBottomSheet01(
                controller: controller,
                order: order,
              );
            },
          ),
        );
      },
    );
  }
}
