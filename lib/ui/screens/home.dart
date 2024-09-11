import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_dio_riverpod/models/current_weather.dart';
import 'package:weather_dio_riverpod/providers/current_weather_provider.dart';
import 'package:weather_dio_riverpod/providers/theme_provider.dart';
import 'package:weather_dio_riverpod/services/weather_services.dart';
import 'package:weather_dio_riverpod/ui/components/secondary_container.dart';
import 'package:weather_dio_riverpod/ui/components/main_search_bar.dart';
import 'package:weather_dio_riverpod/ui/components/main_weather_container.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    ref.refresh(currentWeatherProvider(city));
  }

  @override
  Widget build(BuildContext context) {
    final city = searchController.text;
    final _currentWeather = ref.watch(currentWeatherProvider(city));
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
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MainSearchBar(
                      controller: searchController,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      ref.refresh(currentWeatherProvider(city));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                        // color: Theme.of(context).colorScheme.tertiary,
                        color: const Color.fromRGBO(23, 51, 63, 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              _currentWeather.when(
                data: (weather) {
                  return Column(
                    children: [
                      MainWeatherContainer(
                        imgPath: weather.icon,
                        location: weather.cityName,
                        temperature: weather.temp.temp.toString(),
                        description: weather.weatherDesc,
                        feelsLike: weather.temp.feelsLike.toString(),
                      ),
                      Row(
                        children: [
                          SecondaryContainer(
                            content: Text(
                              '${weather.temp.humidity} %',
                              style: const TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            title: 'Humidity',
                            imgPath: 'images/humidity.svg',
                          ),
                          SecondaryContainer(
                            title: 'Temperature',
                            imgPath: "images/temp.svg",
                            content: Column(
                              children: [
                                Text(
                                  'Min Temp: ${weather.temp.tempMin} °C',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  'Max Temp: ${weather.temp.tempMax} °C',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SecondaryContainer(
                            title: 'Wind',
                            imgPath: "images/wind.svg",
                            content: Text('${weather.windSpeed}m/s'),
                          ),
                          sevenDaysContainer(),
                        ],
                      )
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, stack) => Text('Error: $e'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sevenDaysContainer() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(5),
        height: 160,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.limeAccent),
              child: const Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              " See 7 days Forecast",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.0,
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
