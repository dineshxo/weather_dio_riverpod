
import 'package:weather_dio_riverpod/models/weather_forecast.dart';

class DailyWeather {
  final DateTime date;
  final List<Weather> hourlyData;

  DailyWeather({
    required this.date,
    required this.hourlyData,
  });
}

List<DailyWeather> aggregateWeatherData(List<Weather> weatherList) {
  final dailyWeatherMap = <DateTime, List<Weather>>{};

  for (var weather in weatherList) {
    final date = DateTime.fromMillisecondsSinceEpoch(weather.dateTimeUnix * 1000);
    final day = DateTime(date.year, date.month, date.day);

    if (!dailyWeatherMap.containsKey(day)) {
      dailyWeatherMap[day] = [];
    }
    dailyWeatherMap[day]!.add(weather);
  }

  return dailyWeatherMap.entries.map((entry) {
    return DailyWeather(
      date: entry.key,
      hourlyData: entry.value,
    );
  }).toList();
}
