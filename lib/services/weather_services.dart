import 'package:dio/dio.dart';

import 'package:weather_dio_riverpod/constants/constants.dart';
import 'package:weather_dio_riverpod/models/current_weather.dart';

import '../models/weather_forecast.dart';


class WeatherServices {
  WeatherServices({required this.dio});
   final Dio dio;


   Future<CurrentWeather> fetchCurrentWeather(String city)async{
     final String weatherCityURL= 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$APIKEY';
     try {
       final response = await dio.get(weatherCityURL);

       if (response.statusCode == 200) {
         final Map<String, dynamic> json = response.data;
         return CurrentWeather.fromJson(json);
       } else {
         throw Exception('Failed to load current weather data - response error');
       }
     } catch (err) {
       print('Something went Wrong when fetching current weather : $err');
       throw Exception('Something went wrong.');
     }
  }


  Future<List<Weather>> fetchWeatherForecastData(
      {required double lat,required double lon}) async {

      print('lat : $lat');
      print('lon : $lon');
     final String weatherForecastURL = "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$APIKEY";
    try {
      final response = await dio.get(weatherForecastURL);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['list'];
        return data.map((json) => Weather.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch weather forecast - response error ');
      }
    } catch (e) {
      throw Exception('Failed to load weather forecast: $e');
    }
  }
}



