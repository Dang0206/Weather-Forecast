import 'package:flutter/material.dart';
import 'package:web_forecast_weather/models/location_item.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:web_forecast_weather/providers/location.dart';
import 'package:web_forecast_weather/services/api_service.dart';

var defaultBackgroundColor = const Color.fromARGB(255, 181, 213, 239);
var appBarColor = Colors.blue[900];
var myAppBar = AppBar(
  backgroundColor: appBarColor,
  title: const Text(
    'Weather Dashboard by Son Giang Tran',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  centerTitle: true,
);

var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);

class MyDrawer extends StatefulWidget {
  const MyDrawer(
      {Key? key, required Null Function(dynamic city) onCitySelected})
      : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final TextEditingController _controller = TextEditingController();
  final WeatherService _weatherService = WeatherService();

  bool _loading = false;
  String? _error;
  List<LocationItem> _results = [];

  Future<void> _onSearch() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _weatherService.searchCity(query);
      setState(() {
        _results = data.map((e) => LocationItem.fromJson(e)).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 181, 213, 239),
      elevation: 0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: Text(
                'Enter a City Name',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "E.g., New York, London, Tokyo",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  onSubmitted: (_) => _onSearch(),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _onSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.blue[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      "Search",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "or",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 63, 61, 61),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      "Use Current Location",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_loading) const CircularProgressIndicator(),
                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                if (_results.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final item = _results[index];

                        return ListTile(
                          leading: const Icon(Icons.location_city),
                          title: Text("${item.name}, ${item.country}"),
                          subtitle: Text(item.region),
                          onTap: () {
                            Provider.of<WeatherProvider>(context, listen: false)
                                .selectCity(item.name);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
