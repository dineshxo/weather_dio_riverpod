import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_dio_riverpod/providers/weather_provider.dart';
import 'package:weather_dio_riverpod/ui/screens/weather_forecast_page.dart';
import '../../providers/favorite_provider.dart';
import '../components/main_weather_container.dart';

class FavoritePage extends ConsumerStatefulWidget {
  const FavoritePage({super.key});

  @override
  ConsumerState<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends ConsumerState<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        title: Text(
          'Favorites',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh:()async{
         await ref.read(favoriteProvider.notifier).loadFavorites();
         for (final city in favorites){
           ref.refresh(currentWeatherProvider(city));
         }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: favorites.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy_outlined ,
                          size: 60,
                          color: Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(0.7)),
                     const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'No cities in your favorites list.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final city = favorites[index];

                    return ref.watch(currentWeatherProvider(city)).when(
                          data: (weather) {
                            return Dismissible(
                              key: Key(city),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              onDismissed: (direction) {
                                ref
                                    .read(favoriteProvider.notifier)
                                    .removeFavorite(city);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('$city removed from favorites'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WeatherForecastScreen(
                                          lat: weather.lat, lon: weather.lon),
                                    ),
                                  );
                                },
                                child: MainWeatherContainer(
                                  imgPath: weather.icon,
                                  location: weather.cityName,
                                  temperature: weather.temp.temp.toString(),
                                  description: weather.weatherDesc,
                                  feelsLike: weather.temp.feelsLike.toString(),
                                ),
                              ),
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (e, stack) => Container(
                            decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            child: ListTile(
                              leading: const Icon(
                                Icons.error,
                                color: Colors.white,
                                size: 40,
                              ),
                              title: const Text(
                                'No Connection',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('$e'),
                            ),
                          ),
                        );
                  },
                ),
        ),
      ),
    );
  }
}
