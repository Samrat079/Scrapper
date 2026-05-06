import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:scrapper/Services/AppUserServices/AppUserServices01.dart';
import 'package:scrapper/Services/NominatimServices/NominatimServices02.dart';
import 'package:scrapper/Services/OSRMServices/OSRMService02.dart';
import 'package:scrapper/Services/OrderServices/OrderService02.dart';
import 'package:scrapper/Services/PriceServices/PriceService01.dart';

import '../../Services/AppUserServices/AppUserService02.dart';

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

final providers01 = [
  /// no dependency classes
  Provider(create: (_) => OSRMService02()),
  Provider(create: (_) => NominatimServices02()),
  Provider(create: (_) => PriceService01()),

  /// Dependent classes
  ChangeNotifierProvider(
    create: (context) => AppUserServices02(auth: auth, firestore: firestore),

    /// experiment with non init
  ),

  ChangeNotifierProvider(
    create: (context) {
      final orderService = OrderService02(
        appUserService: context.read<AppUserServices02>(),
        osrm: context.read<OSRMService02>(),
        firestore: firestore,
      );

      /// 🔥 Inject into AppUserService
      context.read<AppUserServices02>().setOrderService(orderService);

      return orderService;
    },
  ),
];
