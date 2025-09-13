import 'package:flutter/material.dart';
import '../constants.dart';
import '../util/my_box.dart';
import '../util/my_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_forecast_weather/ForecastCard.dart';
import 'package:web_forecast_weather/firebase/emailSub.dart';
import 'package:web_forecast_weather/providers/location.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_forecast_weather/firebase/emailSub.dart';

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({Key? key}) : super(key: key);

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  bool _showAllForecast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu'),
            ),
            ListTile(title: Text('Item 1')),
            ListTile(title: Text('Item 2')),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            
            Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
                final weather = weatherProvider.currentWeather;
                if (weather == null) return const SizedBox();

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${weatherProvider.selectedCity} (${weather.date ?? ''})",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text("Temp: ${weather.tempC}°C",
                              style: const TextStyle(color: Colors.white)),
                          Text("Wind: ${weather.windKph} KPH",
                              style: const TextStyle(color: Colors.white)),
                          Text("Humidity: ${weather.humidity}%",
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                      Column(
                        children: [
                          Image.network(
                            "https:${weather.condition.icon}",
                            width: 64,
                            height: 64,
                          ),
                          Text(weather.condition.text,
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showAllForecast ? "All-Day Forecast" : "4-Day Forecast",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showAllForecast = !_showAllForecast;
                    });
                  },
                  child: Text(
                    _showAllForecast ? "Show Less" : "See More",
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            
            AspectRatio(
              aspectRatio: 4,
              child: Consumer<WeatherProvider>(
                builder: (context, weatherProvider, child) {
                  final forecastList = _showAllForecast
                      ? weatherProvider.forecastList
                      : weatherProvider.forecastList.take(4).toList();

                  if (forecastList.isEmpty) {
                    return const Center(
                      child: Text("Loading forecast...",
                          style: TextStyle(color: Colors.black54)),
                    );
                  }

                  return GridView.builder(
                    itemCount: forecastList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      return ForecastCard(forecast: forecastList[index]);
                    },
                  );
                },
              ),
            ),

           
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Consumer<WeatherProvider>(
                      builder: (context, weatherProvider, child) {
                        final history = weatherProvider.searchHistory;
                        if (history.isEmpty) {
                          return const Center(
                              child: Text("No history yet today."));
                        }
                        return ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final item = history[index];
                            return ListTile(
                              leading: Image.network(
                                "https:${item.weather.condition.icon}",
                                width: 40,
                                height: 40,
                              ),
                              title: Text(item.city),
                              subtitle: Text(
                                "${item.weather.tempC}°C, Humidity: ${item.weather.humidity}%",
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                      onTap: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        bool isSubscribed = user != null;

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EmailSubscriptionDialog(
                                isSubscribed: isSubscribed);
                          },
                        );
                      },
                      child: const Text(
                        "Get notified by email",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
