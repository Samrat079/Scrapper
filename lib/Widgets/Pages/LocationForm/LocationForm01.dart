import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_flutter/model/response/nominatim_response.dart';
import 'package:scrapper/Models/Address/Address02.dart';
import 'package:scrapper/Widgets/Custome/Drawers/Drawer01.dart';
import 'package:scrapper/Widgets/Custome/SearchDelegate/encodingDelegate01.dart';

import '../../Custome/CenterColumn/CenterColumb03.dart';

class LocationForm01 extends StatefulWidget {
  const LocationForm01({super.key});

  @override
  State<LocationForm01> createState() => _LocationForm01State();
}

class _LocationForm01State extends State<LocationForm01>
    with TickerProviderStateMixin {
  late final AnimatedMapController _animatedMapController;
  final LatLng _defaultLocation = const LatLng(22.572645, 88.363892);
  final _formKey = GlobalKey<FormBuilderState>();
  LatLng? _selectedLocation;
  NominatimResponse? _selectedPlace;

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
    setState(() {
      _selectedLocation = newLocation;
      _selectedPlace = res;
    });
  }

  void submitHandler() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final houseNo = _formKey.currentState?.fields['houseNo']?.value;
      final phoneNumber = _formKey.currentState!.fields['phoneNumber']?.value;

      Navigator.pop(
        context,
        Address02(
          place: _selectedPlace!,
          houseNo: houseNo,
          phoneNumber: phoneNumber,
        ),
      );
    }
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton.filled(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),

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
        builder: (context) => FormBuilder(
          key: _formKey,
          child: CenterColumb03(
            children: [
              /// location
              FormBuilderTextField(
                name: 'place',
                readOnly: true,
                onTap: () =>
                    showSearch<NominatimResponse?>(
                      context: context,
                      delegate: EncodingDelegate01(),
                    ).then((place) {
                      if (place == null) return;

                      _updatePlace(place);

                      _formKey.currentState?.fields['place']?.didChange(
                        place.displayName,
                      );
                    }),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_pin),
                  suffixIcon: const Icon(Icons.edit_outlined),
                  labelText: 'Area/Locality',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              /// house floor
              FormBuilderTextField(
                name: 'houseNo',
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.house_outlined),
                  labelText: 'House no., Flat, Floor',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              /// Contact number
              FormBuilderTextField(
                name: 'phoneNumber',
                validator: FormBuilderValidators.phoneNumber(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_outlined),
                  labelText: 'Contact number',
                  helperText:
                      'The sanitation worker will use this to contact you',
                  helperStyle: TextStyle(fontStyle: FontStyle.italic),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              /// submit button
              ElevatedButton(
                onPressed: submitHandler,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
