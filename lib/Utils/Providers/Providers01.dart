import 'package:provider/provider.dart';
import 'package:scrapper/Services/OSRMServices/OSRMService01.dart';

final providers01 = [Provider(create: (_) => OSRMService01())];
