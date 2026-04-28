import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:scrapper/Models/Orders/Order01.dart';
import 'package:scrapper/Services/OrderServices/Order01Service.dart';
import 'package:scrapper/Widgets/Custome/Drawers/Drawer01.dart';
import 'package:scrapper/Widgets/Pages/CurrOrderScreen/Widget/AcceptedBottomSheet01.dart';
import 'package:scrapper/Widgets/Pages/CurrOrderScreen/Widget/CurrOrderMap01.dart';
import 'package:scrapper/Widgets/Pages/CurrOrderScreen/Widget/SearchingBottomSheet01.dart';
import 'package:scrapper/theme/theme_extensions.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CurrOrderScreen01 extends StatefulWidget {
  const CurrOrderScreen01({super.key});

  @override
  State<CurrOrderScreen01> createState() => _CurrOrderScreen01State();
}

class _CurrOrderScreen01State extends State<CurrOrderScreen01>
    with TickerProviderStateMixin {
  /// keys
  final GlobalKey<ScaffoldState> key = GlobalKey();
  final orderService = Order01Service();

  /// Controller
  final MapController mapController = MapController();
  final PanelController panelController = PanelController();

  /// Animation controller
  late final _animatedMapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(seconds: 1),
    curve: Curves.easeIn,
    cancelPreviousAnimations: true,
  );

  /// This updates the camera
  void updateCamera() => orderService.addListener(() {
    final loc = orderService.value;
    if (loc == null) return;
    final List<LatLng> points = [loc.destination, loc.sanitarian!.latLng!];
    final bounds = LatLngBounds.fromPoints(points);
    final cameraFit = CameraFit.bounds(
      bounds: bounds,
      padding: context.paddingXXL,
    );
    _animatedMapController.animatedFitCamera(cameraFit: cameraFit);
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
          drawer: Drawer01(),

          /// The appbar as if a floating button
          /// opens the drawer but needs a scaffold key
          floatingActionButton: FloatingActionButton(
            onPressed: () => key.currentState!.openDrawer(),
            backgroundColor: context.colorScheme.surface,
            foregroundColor: context.colorScheme.onSurface,
            child: Icon(Icons.menu_rounded),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniStartTop,

          /// body
          body: SlidingUpPanel(
            controller: panelController,

            /// The map
            body: CurrOrderMap01(
              mapController: _animatedMapController.mapController,
              onMapReady: updateCamera,
              order: order,
            ),

            parallaxEnabled: true,
            parallaxOffset: 0.3,
            backdropTapClosesPanel: true,
            borderRadius: BorderRadius.vertical(top: context.radiusXL.bottomRight),
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
