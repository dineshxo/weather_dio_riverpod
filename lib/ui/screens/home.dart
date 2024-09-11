import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_dio_riverpod/models/current_weather.dart';
import 'package:weather_dio_riverpod/providers/current_weather_provider.dart';
import 'package:weather_dio_riverpod/providers/theme_provider.dart';
import 'package:weather_dio_riverpod/services/weather_services.dart';
import 'package:weather_dio_riverpod/ui/components/main_search_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController searchController = TextEditingController();
  String text = '';


  String _getGreeting(int hour) {
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 15) {
      return "Good Afternoon";
    } else if (hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeProvider.notifier).state =
        !ref.read(themeProvider.notifier).state;
  }

  Future<void> _fetchWeather({required String city}) async {
    await WeatherServices.fetchWeather(city);
  }

  @override
  Widget build(BuildContext context) {
    final city =searchController.text;
    final  _currentWeather = ref.watch(currentWeatherProvider(city));
    int hour = DateTime.now().hour;
    String greeting = _getGreeting(hour);
    bool isLightTheme = ref.watch(themeProvider);




    return Scaffold(
      appBar: AppBar(
        title: Text(
          greeting,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: isLightTheme ? Colors.grey : Colors.limeAccent,
                  shape: BoxShape.circle),
              child: IconButton(
                onPressed: () {
                  toggleTheme(ref);
                },
                icon: isLightTheme
                    ? const Icon(
                        Icons.dark_mode,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.light_mode,
                        color: Colors.black54,
                      ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MainSearchBar(
                controller: searchController,
              ),
              ElevatedButton(
                  onPressed:(){
                    ref.refresh(currentWeatherProvider(city));
                  }, child: Icon(Icons.refresh)),
              _currentWeather.when(
                data: (weather) {
                  return Column(
                    children: [
                      Text('City: ${weather.cityName}'),
                      Text('Weather: ${weather.weatherType}'),
                      Text('Description: ${weather.weatherDesc}'),
                      Text('Temperature: ${weather.temp.temp} °K'),
                      Text('Temperature: ${weather.temp.feelsLike} °K'),
                    ],
                  );
                },
                loading: () => CircularProgressIndicator(),
                error: (e, stack) => Text('Error: $e'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
