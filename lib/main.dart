import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scrapper/Services/AppUserServices/AppUserServices01.dart';
import 'package:scrapper/Services/CustomerServices/CustomerServices01.dart';
import 'package:scrapper/Utils/Router/RouteGen.dart';
import 'package:scrapper/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppUserServices01().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: RouteGen.generateRoute,
      theme: ThemeData(
        brightness: Brightness.light,
        // colorSchemeSeed: const Color.fromRGBO(20, 242, 0, 1),
        colorSchemeSeed: Colors.green,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        // colorSchemeSeed: const Color.fromRGBO(20, 242, 0, 1),
        colorSchemeSeed: Colors.green,
      ),
      themeMode: ThemeMode.system,
    );
  }
}
