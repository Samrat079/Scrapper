import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_flutter/model/response/nominatim_response.dart';
import 'package:scrapper/Widgets/Custome/Drawers/Drawer01.dart';
import 'package:scrapper/Widgets/Custome/SearchDelegate/encodingDelegate01.dart';

import '../../Custome/CenterColumn/CenterColumb03.dart';

class HomeScreen02 extends StatefulWidget {
  const HomeScreen02({super.key});

  @override
  State<HomeScreen02> createState() => _HomeScreen02State();
}

class _HomeScreen02State extends State<HomeScreen02>
    with TickerProviderStateMixin {
  late final AnimatedMapController _animatedMapController;

  final LatLng _defaultLocation = const LatLng(22.572645, 88.363892);

  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _animatedMapController = AnimatedMapController(vsync: this);
  }

  void _updatePlace(NominatimResponse? res) {
    if (res == null) return;

    final lat = double.tryParse(res.lat ?? '');
    final lon = double.tryParse(res.lon ?? '');

    if (lat == null || lon == null) return;

    final newLocation = LatLng(lat, lon);

    _animatedMapController.animateTo(dest: newLocation, zoom: 18);

    setState(() => _selectedLocation = newLocation);
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: Drawer01(),
      appBar: AppBar(),

      body: FlutterMap(
        mapController: _animatedMapController.mapController,
        options: MapOptions(initialCenter: _defaultLocation, initialZoom: 18),
        children: [
          TileLayer(
            urlTemplate: "https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}",
            userAgentPackageName: "com.example.scrapper",
          ),

          MarkerLayer(
            markers: [
              if (_selectedLocation != null)
                Marker(
                  point: _selectedLocation!,
                  width: 40,
                  height: 40,
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
        builder: (context) => CenterColumb03(
          children: [
            /// 🔍 Search Field
            TextField(
              readOnly: true,
              onTap: () async {
                final place = await showSearch<NominatimResponse?>(
                  context: context,
                  delegate: EncodingDelegate01(),
                );

                _updatePlace(place);
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_pin),
                suffixIcon: const Icon(Icons.edit_outlined),
                labelText: 'Area/Locality',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            /// 🏠 Address Field
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.house_outlined),
                labelText: 'House no., Flat, Floor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            /// 📞 Phone Field
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone_outlined),
                labelText: 'Contact number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            /// ✅ Submit Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
