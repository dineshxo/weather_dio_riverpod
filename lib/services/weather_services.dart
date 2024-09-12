import 'package:dio/dio.dart';

import 'package:weather_dio_riverpod/constants/constants.dart';
import 'package:weather_dio_riverpod/models/current_weather.dart';


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
}


// static const weatherLatLonURL = 'https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=5058ed6e6d06bf91b6ef2ef25d80526e';
