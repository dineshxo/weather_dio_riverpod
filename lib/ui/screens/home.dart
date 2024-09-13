import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_dio_riverpod/providers/weather_provider.dart';
import 'package:weather_dio_riverpod/providers/theme_provider.dart';
import 'package:weather_dio_riverpod/ui/components/secondary_container.dart';
import 'package:weather_dio_riverpod/ui/components/main_search_bar.dart';
import 'package:weather_dio_riverpod/ui/components/main_weather_container.dart';
import 'package:weather_dio_riverpod/ui/screens/favorite_page.dart';
import 'package:weather_dio_riverpod/ui/screens/weather_forecast_page.dart';

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





  bool isError = false;



  @override
  Widget build(BuildContext context) {
    final currentWeather = ref.watch(currentWeatherProvider(city));

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
                      color: isLightTheme ? Colors.black54 : Colors.limeAccent,
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
                      color: Colors.redAccent, shape: BoxShape.circle),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FavoritePage()));
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: RefreshIndicator(
          onRefresh: () async{
            ref.refresh(currentWeatherProvider(city));
          },
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
                        ref.refresh(currentWeatherProvider(city));
                        searchController.clear();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        decoration: BoxDecoration(
                          // color: Theme.of(context).colorScheme.tertiary,
                          // color: const Color.fromRGBO(23, 51, 63, 1),
                          color: Colors.black54,
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
                currentWeather.when(
                    data: (weather) {
                      setState(() {
                        isError = true;
                      });
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
                              sevenDaysContainer(
                                  lat: weather.lat, lon: weather.lon),
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
                              SecondaryContainer(
                                content: Text(
                                  '${weather.temp.humidity}%',
                                  style: const TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                                title: 'Humidity',
                                imgPath: 'images/humidity.svg',
                              ),
                            ],
                          )
                        ],
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (e, stack) {
                      setState(() {
                        isError = false;
                      });
                      return Center(child: displayError());
                    }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: isError
          ? FloatingActionButton(
              onPressed: () {
                ref.read(favoriteProvider.notifier).addFavorite(city);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$city added from favorites'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: SvgPicture.asset(
                'images/addFavorite.svg',
                colorFilter:
                    const ColorFilter.mode(Colors.pink, BlendMode.srcIn),
                width: 30,
              ),
            )
          : null,
    );
  }

  Widget sevenDaysContainer({required double lat, required double lon}) {
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
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 6.0,
                    offset: const Offset(0, 5),
                  ),
                ], shape: BoxShape.circle, color: Colors.white),
                child: const Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.black54,
                  size: 30,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherForecastScreen(
                      lat: lat,
                      lon: lon,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            const Text(
              " See 5 days Forecast",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
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

  Widget displayError() {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: screenHeight / 3.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(onPressed: (){
            ref.refresh(currentWeatherProvider(city));
          }, icon: Icon(Icons.refresh, size: 60, color: Colors.red.withOpacity(0.7))),
          const SizedBox(height: 10),
          Text(
            'City Not Found or No Connection !',
            style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.inversePrimary,
                ),
          ),
          Text(
            "Something went wrong.",
            style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
