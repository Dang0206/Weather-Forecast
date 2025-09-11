import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_forecast_weather/providers/location.dart';
import 'package:web_forecast_weather/responsive/desktop_body.dart';
import 'package:web_forecast_weather/responsive/tablet_body.dart';
import 'package:web_forecast_weather/responsive/mobile_body.dart';
import 'package:web_forecast_weather/responsive/responsive_layout.dart';

void main() {
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