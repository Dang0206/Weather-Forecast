import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_forecast_weather/ForecastCard.dart';
import 'package:web_forecast_weather/firebase/emailSub.dart';
import 'package:web_forecast_weather/providers/location.dart';
import '../constants.dart';
import '../util/my_box.dart';
import '../util/my_tile.dart';


class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({Key? key}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  bool _showAllForecast = false; 
  
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      body: Column(
        children: [
          // Hàng chứa nút History nằm ngay dưới AppBar
Align(
  alignment: Alignment.topRight,
  child: IconButton(
    icon: const Icon(Icons.history, color: Colors.black87),
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Search History"),
            content: Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
                final history = weatherProvider.searchHistory;
                if (history.isEmpty) {
                  return const Text("No history yet today.");
                }
                return SizedBox(
                  width: 300,
                  height: 400,
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      return ListTile(
                        leading: Image.network(
                          "https:${item.weather.condition.icon}",
                          width: 40,
                          height: 40,
                        ),
                        title: Text("${item.city}"),
                        subtitle: Text(
                          "${item.weather.tempC}°C, Humidity: ${item.weather.humidity}%",
                        ),
                        
                      );
                    },
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    },
  ),
),



          // Nội dung còn lại
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // open drawer
                  MyDrawer(
                    onCitySelected: (city) {
                      print("Selected city: $city");
                    },
                  ),

                  
                  Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Consumer<WeatherProvider>(
                              builder: (context, weatherProvider, child) {
                                final weather =
                                    weatherProvider.currentWeather;
                                if (weather == null) return const SizedBox();

                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[400],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          Text(
                                            "Temperature: ${weather.tempC}°C",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "Wind: ${weather.windKph} KPH",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "Humidity: ${weather.humidity}%",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Image.network(
                                            "https:${weather.condition.icon}",
                                            width: 64,
                                            height: 64,
                                          ),
                                          Text(
                                            "${weather.condition.text}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            Consumer<WeatherProvider>(
                              builder: (context, weatherProvider, child) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _showAllForecast
                                          ? "All-Day Forecast"
                                          : "4-Day Forecast",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _showAllForecast = !_showAllForecast;
                                        });
                                      },
                                      child: Text(
                                        _showAllForecast
                                            ? "Show Less"
                                            : "See More",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            Expanded(
                              child: Consumer<WeatherProvider>(
                                builder: (context, weatherProvider, child) {
                                  final forecastList = _showAllForecast
                                      ? weatherProvider.forecastList
                                      : weatherProvider.forecastList
                                          .take(4)
                                          .toList();

                                  if (forecastList.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        "Loading forecast...",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    );
                                  }

                                  return SingleChildScrollView(
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: forecastList.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 0.7,
                                      ),
                                      itemBuilder: (context, index) {
                                        return ForecastCard(
                                          forecast: forecastList[index],
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        // Positioned chỉ hoạt động trong Stack
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const EmailSubscriptionDialog();
                                  },
                                );
                              },
                              child: const Text(
                                "Get notified by email",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}