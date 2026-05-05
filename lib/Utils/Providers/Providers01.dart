import 'package:provider/provider.dart';
import 'package:scrapper/Services/NominatimServices/NominatimServices01.dart';
import 'package:scrapper/Services/OSRMServices/OSRMService01.dart';

final providers01 = [
  /// no dependency classes
  Provider(create: (_) => OSRMService01()),
  Provider(create: (_) => NominatimServices01()),
];
