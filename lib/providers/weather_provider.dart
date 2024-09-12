import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_dio_riverpod/models/current_weather.dart';
import 'package:weather_dio_riverpod/services/weather_services.dart';
import 'package:dio/dio.dart';

import '../models/daily_weather_forecast.dart';
import '../models/weather_forecast.dart';


final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final weatherServicesProvider = Provider<WeatherServices>((ref) {
  final dio = ref.read(dioProvider);
  return WeatherServices(dio: dio);
});

final currentWeatherProvider = FutureProvider.family<CurrentWeather, String>((ref, String city) {
  final weatherService = ref.read(weatherServicesProvider);
  return weatherService.fetchWeather(city);
});

final weatherProvider = FutureProvider<List<Weather>>((ref)  {
  final weatherService = ref.read(weatherServicesProvider);
  return weatherService.fetchWeatherData(); // Call the service function
});

// Aggregating weather data by day
final dailyWeatherProvider = FutureProvider<List<DailyWeather>>((ref) async {
  final weatherList = await ref.watch(weatherProvider.future);
  return aggregateWeatherData(weatherList);
});
