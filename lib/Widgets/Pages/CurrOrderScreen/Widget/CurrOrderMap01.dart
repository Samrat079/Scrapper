import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:scrapper/Models/Orders/Order01.dart';

import '../../../../theme/theme_extensions.dart';

class CurrOrderMap01 extends StatelessWidget {
  final MapController mapController;
  final VoidCallback onMapReady;
  final Order01 order;

  const CurrOrderMap01({
    super.key,
    required this.mapController,
    required this.onMapReady,
    required this.order,
  });

  /// Map urls
  final mapUrl = "https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}";
  final packageId = "com.example.scrapper";

  @override
  Widget build(BuildContext context) => FlutterMap(
    mapController: mapController,
    options: MapOptions(
      onMapReady: onMapReady,
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

          /// Destination marker
          Marker(
            point: order.destination,
            child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
          ),

          /// If sanitarian is null it
          /// wont show the marker
          if (order.sanitarian != null)
            Marker(
              point: order.sanitarian!.latLng!,
              child: Icon(
                CupertinoIcons.car_detailed,
                size: 40,
                color: context.colorScheme.surface,
              ),
            ),
        ],
      ),
    ],
  );
}
