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
  @override
  Widget build(BuildContext context) {
    /// Map urls
    final mapUrl = "https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}";
    final packageId = "com.example.scrapper";

    /// keys
    final GlobalKey<ScaffoldState> key = GlobalKey();
    final orderService = Order01Service();

    /// Controller
    final MapController mapController = MapController();
    final PanelController panelController = PanelController();

    /// This updates the camera
    void updateCam(Order01 order) {
      if (order.sanitarian?.latLng == null) return;
      final List<LatLng> points = [
        order.destination,
        order.sanitarian!.latLng!,
      ];

      final bounds = LatLngBounds.fromPoints(points);

      mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(80)),
      );
    }

    return ValueListenableBuilder<Order01?>(
      valueListenable: orderService,
      builder: (context, order, _) {
        if (order == null) {
          return Center(child: CircularProgressIndicator());
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => updateCam(order));

        return Scaffold(
          key: key,
          extendBodyBehindAppBar: true,
          drawer: Drawer01(),
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
            body: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: order.destination,
                initialZoom: 18,
              ),
              children: [
                TileLayer(urlTemplate: mapUrl, userAgentPackageName: packageId),

                /// Remember to put the not empty check
                /// else it will error out
                if (order.routesRes.coordinates.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: order.routesRes.coordinates,
                        strokeWidth: 4,
                        color: context.colorScheme.surface,
                      ),
                    ],
                  ),

                MarkerLayer(
                  markers: [
                    Marker(
                      point: order.destination,
                      child: const Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                    if (order.sanitarian != null)
                      Marker(
                        point: order.sanitarian!.latLng!,
                        child: Icon(
                          CupertinoIcons.car_detailed,
                          size: 40,
                          color: context.colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ],
            ),

            parallaxEnabled: true,
            parallaxOffset: 0.3,
            borderRadius: BorderRadius.vertical(top: context.radiusLG.topLeft),
            color: context.colorScheme.surface,
            panelBuilder: (ScrollController controller) {
              /// If there is not sanitarian
              /// Remember to put return statement in this
              if (order.sanitarian == null) {
                panelController.open();
                return CenterColumn04(
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

              /// If a sanitarian accepts the order
              /// this has return so wont crash
              panelController.open();
              return CenterColumn04(
                scrollController: controller,
                children: [
                  /// Sanitarian info
                  ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: order.sanitarian!.photoUrl,
                      imageBuilder: (context, provider) =>
                          CircleAvatar(backgroundImage: provider),
                      placeholder: (context, url) => Icon(Icons.person_outline),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error_outline),
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
            },
          ),
        );
      },
    );
  }
}
