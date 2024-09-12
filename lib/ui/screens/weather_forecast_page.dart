import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../../providers/weather_provider.dart';
import 'package:intl/intl.dart';

class WeatherForecastScreen extends ConsumerStatefulWidget {
  const WeatherForecastScreen({required this.lat, required this.lon, super.key});

  final double lat;
  final double lon;

  @override
  ConsumerState<WeatherForecastScreen> createState() => _WeatherForecastScreenState();
}


class _WeatherForecastScreenState extends ConsumerState<WeatherForecastScreen> {


  @override
  Widget build(BuildContext context) {
    var coordinates = Tuple2(widget.lat, widget.lon);
    final dailyWeather = ref.watch(dailyWeatherProvider(coordinates));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        title: Text(
          'Weather Forecast',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      body: dailyWeather.when(
        data: (dailyWeatherList) {
          if (dailyWeatherList.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          return ListView.builder(
            itemCount: dailyWeatherList.length,
            itemBuilder: (context, index) {
              final dailyWeather = dailyWeatherList[index];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade100.withOpacity(0.4),
                      Colors.blueAccent.shade100.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMMM d').format(dailyWeather.date),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Column(
                      children: dailyWeather.hourlyData.map((weather) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.network(
                                  'http://openweathermap.org/img/wn/${weather.icon}.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  DateFormat('HH:mm').format(
                                    DateTime.fromMillisecondsSinceEpoch(weather.dateTimeUnix * 1000),
                                  ),
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${weather.temperature.toStringAsFixed(1)}°C',
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        weather.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                          fontWeight: FontWeight.w900,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(

          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  ref.refresh(dailyWeatherProvider(Tuple2(widget.lat, widget.lon)));
                },
                icon: Icon(Icons.refresh, size: 60, color: Colors.red.withOpacity(0.7)),
              ),
              Text(
                'No Connection',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              Text(
              "$error"
                ),

            ],
          ),
        ),
      ),
    );
  }
}
