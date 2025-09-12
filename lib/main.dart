import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_forecast_weather/providers/location.dart';
import 'package:web_forecast_weather/responsive/desktop_body.dart';
import 'package:web_forecast_weather/responsive/tablet_body.dart';
import 'package:web_forecast_weather/responsive/mobile_body.dart';
import 'package:web_forecast_weather/responsive/responsive_layout.dart';
import 'package:firebase_core/firebase_core.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD4z6827CseDBd8L5eas8R0u5eIAOdzjMs",
      authDomain: "email-confirmation-71f1b.firebaseapp.com",
      projectId: "email-confirmation-71f1b",
      storageBucket: "email-confirmation-71f1b.firebasestorage.app",
      messagingSenderId: "13461059601",
      appId: "1:13461059601:web:ff74e1b117cc1a5c4c19b0",
      measurementId: "G-162QWBPPZX",
    ),
  );

runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: ResponsiveLayout(
        mobileBody: const MobileScaffold(),
        tabletBody: const TabletScaffold(),
        desktopBody: const DesktopScaffold(),
      ),
    );
  }
}