import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_dio_riverpod/providers/current_weather_provider.dart';
import '../../providers/favorite_provider.dart';
import '../components/main_weather_container.dart';

class FavoritePage extends ConsumerWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,),
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
                      child: MainWeatherContainer(
                        imgPath: weather.icon,
                        location: weather.cityName,
                        temperature: weather.temp.temp.toString(),
                        description: weather.weatherDesc,
                        feelsLike: weather.temp.feelsLike.toString(),
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, stack) => Text('Error: $e'),
                );
          },
        ),
      ),
    );
  }
}
