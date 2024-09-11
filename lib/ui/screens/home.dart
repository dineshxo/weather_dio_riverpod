import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_dio_riverpod/providers/current_weather_provider.dart';
import 'package:weather_dio_riverpod/providers/theme_provider.dart';
import 'package:weather_dio_riverpod/ui/components/secondary_container.dart';
import 'package:weather_dio_riverpod/ui/components/main_search_bar.dart';
import 'package:weather_dio_riverpod/ui/components/main_weather_container.dart';
import 'package:weather_dio_riverpod/ui/screens/favorite_page.dart';

import '../../providers/favorite_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController searchController = TextEditingController();
  String city = "Colombo";

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

  void showCustomSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.green,

      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final _currentWeather = ref.watch(currentWeatherProvider(city));

    int hour = DateTime.now().hour;
    String greeting = _getGreeting(hour);
    bool isLightTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hello, $greeting !',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.inversePrimary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
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
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.pinkAccent, shape: BoxShape.circle),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>const FavoritePage()));
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(favoriteProvider.notifier).addFavorite(city);
          showCustomSnackBar(context,'$city added to favorites');
        },
        child: SvgPicture.asset('images/addFavorite.svg',
          colorFilter: const ColorFilter.mode(
              Colors.pink, BlendMode.srcIn),
        width: 30,),
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
                      if (searchController.text.isNotEmpty) {
                        setState(() {
                          city = searchController.text;
                        });
                      }

                      searchController.clear();
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
                                  color: Colors.white),
                            ),
                            title: 'Humidity',
                            imgPath: 'images/humidity.svg',
                          ),
                          SecondaryContainer(
                            title: 'Wind',
                            imgPath: "images/wind.svg",
                            content: Text(
                              '${weather.windSpeed}m/s',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SecondaryContainer(
                            title: 'Temperature',
                            titleColor: Colors.white,
                            imgPath: "images/temp.svg",
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade100.withOpacity(0.3),
                                Colors.blueAccent.shade100.withOpacity(0.5)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            content: Column(
                              children: [
                                Text(
                                  'Min Temp: ${weather.temp.tempMin} °C',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Max Temp: ${weather.temp.tempMax} °C',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
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
        height: 170,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.yellow.shade200,
              Colors.yellow.shade800,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: const Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              " See 7 days Forecast",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.0,
                // color: Theme.of(context).colorScheme.inversePrimary,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
