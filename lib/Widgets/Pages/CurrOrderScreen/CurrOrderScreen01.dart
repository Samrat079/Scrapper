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

        final coordinates = LatLng(
          double.parse(order.address.place.lat!),
          double.parse(order.address.place.lon!),
        );

        void cancelOrder() async {
          await Order01Service().cancelCurrOrder();
        }

        return Scaffold(
          key: key,
          extendBodyBehindAppBar: true,
          drawer: Drawer01(),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton.filled(
              onPressed: () => key.currentState!.openDrawer(),
              icon: Icon(Icons.menu_outlined),
              style: IconButton.styleFrom(
                backgroundColor: context.colorScheme.surface,
              ),
            ),
          ),
          body: FlutterMap(
            options: MapOptions(initialCenter: coordinates, initialZoom: 18),
            children: [
              TileLayer(
                urlTemplate:
                    "https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}",
                userAgentPackageName: "com.example.scrapper",
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: coordinates,
                    child: const Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottomSheet: BottomSheet(
            onClosing: () {},
            builder: (context) {

              /// Temporary testing logic change this to == in prod
              if (order.sanitarian != null) {
                return CenterColumn04(
                  padding: context.paddingMD,
                  children: [
                    context.gapMD,
                    Center(child: CircularProgressIndicator()),
                    context.gapMD,
                    Text(
                      'Looking for sanitarians in your area',
                      textAlign: TextAlign.center,
                    ),
                    context.gapMD,
                    ElevatedButton(
                      onPressed: cancelOrder,
                      child: Text('Cancel'),
                    ),
                  ],
                );
              }

              return CenterColumn04(
                padding: context.paddingLG,
                children: [
                  Text(order.address.place.displayName!),
                  context.gapMD,
                  Text(order.address.houseNo),
                  context.gapMD,
                  Text(order.sanitarian?.displayName ?? 'Sanitarian name'),
                  context.gapMD,
                  ElevatedButton(onPressed: cancelOrder, child: Text('Cancel')),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
