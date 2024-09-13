import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
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
  return weatherService.fetchCurrentWeather(city);
});



final weatherProvider = FutureProvider.family<List<Weather>, Tuple2<double, double>>((ref, coordinates) {
  final weatherService = ref.read(weatherServicesProvider);
  final lat = coordinates.item1;
  final lon = coordinates.item2;
  return weatherService.fetchWeatherForecastData(lat: lat, lon: lon);
});



final dailyWeatherProvider = FutureProvider.family<List<DailyWeather>, Tuple2<double, double>>((ref, coordinates) async {
  final weatherList = await ref.watch(weatherProvider(coordinates).future);
  return aggregateWeatherData(weatherList);
});
