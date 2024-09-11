class CurrentWeather {
  final String cityName;
  final String weatherType;
  final String weatherDesc;
  final String icon;
  final Temp temp;

  CurrentWeather({
    required this.weatherType,
    required this.weatherDesc,
    required this.icon,
    required this.temp,
    required this.cityName,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {

    final tempData = json['main'];
    final temp = Temp.fromJson(tempData);


    final weatherList = json['weather'] as List<dynamic>;
    if (weatherList.isEmpty) {
      throw Exception('Weather data is empty');
    }
    final weatherData = weatherList[0] as Map<String, dynamic>;

    return CurrentWeather(
      cityName: json['name'] as String,
      weatherType:weatherData['main'],
      weatherDesc: weatherData['description'],
      icon: weatherData['icon'],
      temp: temp,
    );
  }
}

class Temp {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;

  Temp({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
  });

  factory Temp.fromJson(Map<String, dynamic> json) {
    return Temp(
      temp: (json['temp'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      tempMin: (json['temp_min'] as num).toDouble(),
      tempMax: (json['temp_max'] as num).toDouble(),
      humidity: json['humidity'] as int,
    );
  }
}
