import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_flutter/model/response/nominatim_response.dart';
import 'package:provider/provider.dart';
import 'package:scrapper/Models/Address/Address02.dart';
import 'package:scrapper/Services/AppUserServices/AppUserService02.dart';
import 'package:scrapper/Services/AppUserServices/AppUserServices01.dart';
import 'package:scrapper/Services/PriceServices/PriceService01.dart';
import 'package:scrapper/Widgets/Custome/SearchDelegate/encodingDelegate01.dart';
import 'package:scrapper/theme/theme_extensions.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../Services/NominatimServices/NominatimServices02.dart';
import '../../Custome/CenterColumn/CenterColumn04.dart';

class LocationForm01 extends StatefulWidget {
  const LocationForm01({super.key});

  @override
  State<LocationForm01> createState() => _LocationForm01State();
}

class _LocationForm01State extends State<LocationForm01>
    with TickerProviderStateMixin {
  late final AnimatedMapController _animatedMapController;
  late final PriceService01 priceService;
  late final NominatimServices02 nominatim;
  late final AppUserServices02 appUserService;

  final LatLng _defaultLocation = const LatLng(22.572645, 88.363892);
  final _formKey = GlobalKey<FormBuilderState>();
  final _panelController = PanelController();
  double cost = 0;
  LatLng? _selectedLocation;
  NominatimResponse? _selectedPlace;

  @override
  void initState() {
    super.initState();
    priceService = context.read<PriceService01>();
    nominatim = context.read<NominatimServices02>();
    appUserService = context.read<AppUserServices02>();
    _animatedMapController = AnimatedMapController(vsync: this);
  }

  void _updatePlace(NominatimResponse? res) {
    if (res == null) return;
    final lat = double.tryParse(res.lat ?? '');
    final lon = double.tryParse(res.lon ?? '');
    if (lat == null || lon == null) return;
    final newLocation = LatLng(lat, lon);
    final newCost = priceService.basePrice();
    _animatedMapController.animateTo(dest: newLocation, zoom: 18);
    _formKey.currentState?.fields['place']?.didChange(res.displayName);
    setState(() {
      _selectedLocation = newLocation;
      _selectedPlace = res;
      cost = newCost;
    });
  }

  void submitHandler() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final houseNo = _formKey.currentState?.fields['houseNo']?.value as String;
      final phoneNumber =
          _formKey.currentState!.fields['phoneNumber']?.value as String;

      Navigator.pop(context, {
        "place": _selectedPlace!,
        "houseNo": houseNo,
        "phoneNumber": phoneNumber,
        "price": cost,
      });
    }
  }

  void _onMapTap(LatLng latLng) async {
    setState(() {
      _selectedLocation = latLng;
      cost = priceService.basePrice();
    });

    _animatedMapController.animateTo(
      dest: latLng,
      zoom: 14,
      duration: Duration(seconds: 1),
    );

    _panelController.open();
    _formKey.currentState?.fields['place']?.didChange("Loading...");
    final place = await nominatim.reverse(latLng);
    setState(() => _selectedPlace = place);
    _formKey.currentState?.fields['place']?.didChange(place.displayName);
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
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: context.colorScheme.surface,
        foregroundColor: context.colorScheme.onSurface,
        child: const Icon(Icons.arrow_back),
      ),

      body: SlidingUpPanel(
        body: FlutterMap(
          mapController: _animatedMapController.mapController,
          options: MapOptions(
            initialCenter: _defaultLocation,
            initialZoom: 18,
            onTap: (tapPosition, point) => _onMapTap(point),
          ),
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
                    child: Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ],
        ),

        ///////////////// Panel /////////////////////
        controller: _panelController,
        parallaxEnabled: true,
        defaultPanelState: PanelState.OPEN,
        parallaxOffset: 0.3,
        borderRadius: BorderRadius.vertical(top: context.radiusXL.topLeft),
        color: context.colorScheme.surfaceContainerLowest,
        panelBuilder: (ScrollController controller) => SafeArea(
          child: FormBuilder(
            key: _formKey,
            child: CenterColumn04(
              scrollController: controller,
              children: [
                /// Top form
                Icon(Icons.add_location_alt_outlined, size: 80),
                context.gapLG,

                Text(
                  "Choose the location where do you want the pick up",
                  style: context.textTheme.titleMedium,
                ),
                context.gapMD,

                /// location
                FormBuilderTextField(
                  name: 'place',
                  readOnly: true,
                  validator: FormBuilderValidators.required(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTap: () => showSearch<NominatimResponse?>(
                    context: context,
                    delegate: EncodingDelegate01(),
                  ).then((place) => _updatePlace(place)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.location_pin,
                      color: context.colorScheme.primary,
                    ),
                    suffixIcon: const Icon(Icons.edit_outlined),
                    labelText: 'Area/Locality',
                    filled: true,
                    fillColor: context.colorScheme.surfaceContainer,
                  ),
                ),

                context.gapMD,

                /// house floor
                FormBuilderTextField(
                  name: 'houseNo',
                  validator: FormBuilderValidators.required(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.house_outlined,
                      color: context.colorScheme.primary,
                    ),
                    labelText: 'House no., Flat, Floor',
                    filled: true,
                    fillColor: context.colorScheme.surfaceContainer,
                  ),
                ),
                context.gapMD,

                /// Contact number
                FormBuilderField(
                  name: 'phoneNumber',
                  initialValue: appUserService.current.customer01?.phoneNumber,
                  builder: (field) {
                    return IntlPhoneField(
                      initialValue: field.value,
                      onChanged: (phone) =>
                          field.didChange(phone.completeNumber),
                      initialCountryCode: 'IN',
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.colorScheme.surfaceContainer,
                        labelText: 'Contact number',
                        helperText:
                            'The sanitation worker will use this to contact you',
                      ),
                    );
                  },
                ),
                context.gapMD,

                /// submit button
                ElevatedButton(
                  onPressed: submitHandler,
                  child: Text(cost > 0 ? "Rs.$cost" : "Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
