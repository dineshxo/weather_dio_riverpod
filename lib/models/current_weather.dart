class CurrentWeather {
  final String cityName;
  final double lon;
  final double lat;
  final String weatherType;
  final String weatherDesc;
  final String icon;
  final double windSpeed;
  final Temp temp;

  CurrentWeather( {
    required this.weatherType,
    required this.weatherDesc,
    required this.icon,
    required this.temp,
    required this.cityName,
    required this.windSpeed,
    required this.lat,
    required this.lon,
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
      lat: (json["coord"]["lat"] as num).toDouble(),
      lon: (json["coord"]["lon"] as num).toDouble(),
      cityName: json['name'] as String,
      weatherType:weatherData['main'],
      weatherDesc: weatherData['description'],
      icon: weatherData['icon'],
      windSpeed: (json["wind"]["speed"] as num).toDouble(),
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
      temp: _kelvinToCelsius((json['temp'] as num).toDouble()),
      feelsLike: _kelvinToCelsius((json['feels_like'] as num).toDouble()),
      tempMin: _kelvinToCelsius((json['temp_min'] as num).toDouble()),
      tempMax: _kelvinToCelsius((json['temp_max'] as num).toDouble()),
      humidity: json['humidity'] as int,
    );
  }

  static double _kelvinToCelsius(double kelvin) {
    return double.parse((kelvin - 273.15).toStringAsFixed(1));
  }
}

