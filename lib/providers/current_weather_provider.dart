import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_dio_riverpod/models/current_weather.dart';
import 'package:weather_dio_riverpod/services/weather_services.dart';

final currentWeatherProvider = FutureProvider.family<CurrentWeather,String>((ref,String city){
  return WeatherServices.fetchWeather(city);
});