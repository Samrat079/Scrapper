import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:scrapper/Models/Orders/Order01.dart';
import 'package:scrapper/Services/OrderServices/OrderService01.dart';
import 'package:scrapper/Widgets/Custome/CenterColumn/CenterColumn04.dart';
import 'package:scrapper/Widgets/Custome/Drawers/Drawer01.dart';
import 'package:scrapper/Widgets/Pages/CurrOrderScreen/Widget/AcceptedBottomSheet01.dart';
import 'package:scrapper/Widgets/Pages/CurrOrderScreen/Widget/CurrOrderMap01.dart';
import 'package:scrapper/Widgets/Pages/CurrOrderScreen/Widget/SearchingBottomSheet01.dart';
import 'package:scrapper/theme/theme_extensions.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:scrapper/Models/Orders/Order01.dart';
import 'package:scrapper/Services/OrderServices/OrderService02.dart';

// import 'package:scrapper/Services/OrderServices/OrderService01.dart'; // ❌ OLD
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

  /// Controller
  final MapController mapController = MapController();
  final PanelController panelController = PanelController();

  /// Animation controller
  late final AnimatedMapController _animatedMapController =
      AnimatedMapController(
        vsync: this,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
        cancelPreviousAnimations: true,
      );

  ///  NEW camera updater
  void _updateCamera(BuildContext context, Order01 order) {
    if (order.sanitarian == null || order.sanitarian?.latLng == null) return;

    final points = [order.destination, order.sanitarian!.latLng!];
    final bounds = LatLngBounds.fromPoints(points);

    final cameraFit = CameraFit.bounds(
      bounds: bounds,
      padding: EdgeInsets.all(180),
    );

    _animatedMapController.animatedFitCamera(cameraFit: cameraFit);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderService02>(
      builder: (context, orderService, _) {
        final order = orderService.current;

        if (order == null) {
          return const Center(child: CircularProgressIndicator());
        }

        /// Need to have this coz on map ready doesn't works
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateCamera(context, order);
        });

        return Scaffold(
          key: key,
          drawer: Drawer01(),

          /// Floating menu button
          floatingActionButton: FloatingActionButton(
            onPressed: () => key.currentState!.openDrawer(),
            backgroundColor: context.colorScheme.surface,
            foregroundColor: context.colorScheme.onSurface,
            child: const Icon(Icons.menu_rounded),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniStartTop,

          /// Body
          body: SlidingUpPanel(
            controller: panelController,

            /// Map
            body: CurrOrderMap01(
              mapController: _animatedMapController.mapController,
              onMapReady: () {},
              order: order,
            ),

            parallaxEnabled: true,
            parallaxOffset: 0.5,
            backdropTapClosesPanel: true,
            defaultPanelState: PanelState.OPEN,
            borderRadius: BorderRadius.vertical(
              top: context.radiusXL.bottomRight,
            ),
            color: context.colorScheme.surfaceContainerLowest,

            panelBuilder: (ScrollController controller) {
              /// Searching state
              if (order.status == Order01Status.requested &&
                  order.sanitarian == null) {
                return SearchingBottomSheet01(
                  controller: controller,
                  order: order,
                  onIncrement: () => orderService.updatePrice(order.price + 10),
                  onDecrement: () => orderService.updatePrice(order.price - 10),
                  onCancel: () => orderService.cancelCurrOrder(),
                );
              }

              if (order.status == Order01Status.cancelled) {
                return SafeArea(
                  child: CenterColumn04(
                    children: [
                      Text("Order canceled"),
                      ElevatedButton(
                        onPressed: orderService.stop,
                        child: Text("Done"),
                      ),
                    ],
                  ),
                );
              }

              if (order.status == Order01Status.completed) {
                return SafeArea(
                  child: CenterColumn04(
                    children: [
                      Text("Order completed"),
                      ElevatedButton(
                        onPressed: orderService.stop,
                        child: Text("Done"),
                      ),
                    ],
                  ),
                );
              }

              /// Accepted state
              return AcceptedBottomSheet01(
                controller: controller,
                order: order,
                onCancel: () => orderService.cancelCurrOrder(),
              );
            },
          ),
        );
      },
    );
  }
}
