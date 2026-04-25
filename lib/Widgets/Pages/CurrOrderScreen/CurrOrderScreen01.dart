import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duration/duration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:scrapper/Models/Orders/Order01.dart';
import 'package:scrapper/Services/OrderServices/Order01Service.dart';
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
    final MapController _mapController = MapController();

    return ValueListenableBuilder<Order01?>(
      valueListenable: orderService,
      builder: (context, order, _) {
        if (order == null) {
          return Center(child: CircularProgressIndicator());
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (order.sanitarian?.latLng != null) {
            final points = [order.destination, order.sanitarian!.latLng!];

            final bounds = LatLngBounds.fromPoints(points);

            _mapController.fitCamera(
              CameraFit.bounds(
                bounds: bounds,
                padding: const EdgeInsets.all(80),
              ),
            );
          }
        });

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
            body: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: order.destination,
                initialZoom: 18,
              ),
              children: [
                TileLayer(urlTemplate: mapUrl, userAgentPackageName: packageId),

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
            maxHeight: MediaQuery.of(context).size.height * 0.6,
            borderRadius: BorderRadius.vertical(top: context.radiusMD.topLeft),
            color: context.colorScheme.surface,
            panelBuilder: (ScrollController controller) {
              /// If there is not sanitarian
              if (order.sanitarian == null) {
                CenterColumn04(
                  padding: context.paddingMD,
                  scrollController: controller,
                  children: [
                    context.gapMD,
                    const Center(child: CircularProgressIndicator()),
                    context.gapMD,
                    const Text(
                      'Looking for sanitarians in your area',
                      textAlign: TextAlign.center,
                    ),
                    Text(order.address.place.name.toString()),
                    context.gapMD,
                    ElevatedButton(
                      onPressed: () => Order01Service().cancelCurrOrder(),
                      child: const Text('Cancel'),
                    ),
                  ],
                );
              }

              /// If a sanitarian accepts the order
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
