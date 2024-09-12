import 'package:dio/dio.dart';

import 'package:weather_dio_riverpod/constants/constants.dart';
import 'package:weather_dio_riverpod/models/current_weather.dart';

import '../models/weather_forecast.dart';


class WeatherServices {
  WeatherServices({required this.dio});
   final Dio dio;


   Future<CurrentWeather> fetchWeather(String city)async{
     final String weatherCityURL= 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$APIKEY';
     try {
       final response = await dio.get(weatherCityURL);

       if (response.statusCode == 200) {
         final Map<String, dynamic> json = response.data;
         return CurrentWeather.fromJson(json);
       } else {
         throw Exception('Failed to load weather data');
       }
     } catch (err) {
       print('Something went Wrong: $err');
       throw Exception('Failed to load weather data');
     }
  }


  Future<List<Weather>> fetchWeatherData() async {

     const String weatherForecastURL = "https://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=$APIKEY";
    try {
      final response = await dio.get(weatherForecastURL);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['list'];
        return data.map((json) => Weather.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }
}



