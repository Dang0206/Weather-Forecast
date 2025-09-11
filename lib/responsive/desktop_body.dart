import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_forecast_weather/ForecastCard.dart';
import 'package:web_forecast_weather/emailSub.Dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer
              MyDrawer(   // <-- correctly set here
    onCitySelected: (city) {
      print("Selected city: $city");
    },
  ),

            // first half of page
            Expanded(
              flex: 2,
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
        color: Colors.blue[400],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // Sử dụng .date thay vì ['date']
                "${weatherProvider.selectedCity} (${weather.date ?? ''})",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // Sử dụng .tempC thay vì ['tempC']
              Text("Temperature: ${weather.tempC}°C", style: const TextStyle(color: Colors.white)),
              // Sử dụng .windKph thay vì ['windKph']
              Text("Wind: ${weather.windKph} KPH", style: const TextStyle(color: Colors.white)),
              // Sử dụng .humidity thay vì ['humidity']
              Text("Humidity: ${weather.humidity}%", style: const TextStyle(color: Colors.white)),
            ],
          ),
          Column(
            children: [
              Image.network(
                "https:${weather.condition.icon}",
                width: 64,
                height: 64,
              ),
              Text("${weather.condition.text}", style: const TextStyle(color: Colors.white)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _showAllForecast ? "All-Day Forecast" : "4-Day Forecast",
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showAllForecast = !_showAllForecast; 
                                  });
                                },
                                child: Text(
                                  _showAllForecast ? "Show Less" : "See More",
                                  style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
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
                                : weatherProvider.forecastList.take(4).toList();

                            if (forecastList.isEmpty) {
                              return const Center(child: Text("Loading forecast...", style: TextStyle(color: Colors.black54)));
                            }

                            return SingleChildScrollView(
                              child: GridView.builder(
                                shrinkWrap: true, 
                                physics: const NeverScrollableScrollPhysics(), 
                                itemCount: forecastList.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.7,
                                ),
                                itemBuilder: (context, index) {
                                  return ForecastCard(forecast: forecastList[index]);
                                },
                              ),
                            );
                          },
                        ),
                      ),


 Positioned(
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: GestureDetector( // Sử dụng GestureDetector để có thể nhấn
                        onTap: () {
                          // Gọi showDialog khi người dùng nhấn vào
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const EmailSubscriptionDialog();
                            },
                          );
                        },
                        child: const Text( // Đổi sang const Text để tối ưu
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
    );
    
  }
}
