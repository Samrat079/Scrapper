import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper/Services/AppUserServices/AppUserServices01.dart';
import 'package:scrapper/Utils/Providers/Providers01.dart';
import 'package:scrapper/Utils/Router/RouteGen.dart';
import 'package:scrapper/firebase_options.dart';
import 'package:scrapper/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await AppUserServices01().init();
  runApp(MultiProvider(providers: providers01, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) => generateRoute(settings, context),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
