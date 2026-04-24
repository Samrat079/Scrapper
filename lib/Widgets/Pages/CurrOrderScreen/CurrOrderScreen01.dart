import 'package:cloud_firestore/cloud_firestore.dart';
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

class CurrOrderScreen01 extends StatelessWidget {
  const CurrOrderScreen01({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();
    return ValueListenableBuilder<Order01?>(
      valueListenable: Order01Service(),
      builder: (context, order, _) {
        if (order == null) {
          return Center(child: CircularProgressIndicator());
        }

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
            /// 🔥 MAP GOES HERE
            body: FlutterMap(
              options: MapOptions(
                initialCenter: order.destination,
                initialZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}",
                  userAgentPackageName: "com.example.scrapper",
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
                        point: order.sanitarian?.latLng ?? order.destination,
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
            borderRadius: BorderRadius.vertical(top: context.radiusMD.topLeft),
            color: context.colorScheme.surface,
            panelBuilder: (ScrollController controller) {
              if (order.sanitarian == null) {
                return CenterColumn04(
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

              return CenterColumn04(
                padding: context.paddingLG,
                scrollController: controller,
                children: [
                  Text(order.address.place.displayName!),
                  context.gapMD,
                  Text(order.address.houseNo),
                  context.gapMD,
                  Text(order.sanitarian!.displayName),
                  context.gapMD,
                  Text(order.sanitarian!.phoneNumber),
                  context.gapMD,
                  Text(order.sanitarian!.latLng.toString() ?? 'No data'),
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
