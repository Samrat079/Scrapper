import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:scrapper/Widgets/Custome/BottomSheet/BottomSheet01.dart';

class HomeScreen02 extends StatefulWidget {
  const HomeScreen02({super.key});

  @override
  State<HomeScreen02> createState() => _HomeScreen02State();
}

class _HomeScreen02State extends State<HomeScreen02> {
  final MapController _mapController = MapController();

  Future<void> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services are disabled');
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  // Future<void> _initLocation() async {
  //   await _requestPermission();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home 2')),
      body: FlutterMap(
        mapController: _mapController,
        options: const MapOptions(
          initialCenter: LatLng(22.572645, 88.363892),
          initialZoom: 10,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}",
            userAgentPackageName: "com.example.scrapper",
          ),
          CurrentLocationLayer(
            style: const LocationMarkerStyle(
              marker: DefaultLocationMarker(
                child: Icon(Icons.location_pin),
              ),
              markerSize: Size(34, 34),
              markerDirection: MarkerDirection.heading,
            ),
          ),
        ],
      ),
      // bottomSheet: BottomSheet01(),
    );
  }
}
