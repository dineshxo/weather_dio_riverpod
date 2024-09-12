class Weather {
  final int dateTimeUnix;
  final double temperature;
  final String description;
  final String icon;
  final String dateTimeText;

  Weather({
    required this.dateTimeUnix,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.dateTimeText,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];

    return Weather(
      dateTimeUnix: json['dt'],
      temperature: _kelvinToCelsius(main['temp'].toDouble()),
      description: weather['description'],
      icon: weather['icon'],
      dateTimeText: json['dt_txt'],
    );


  }

  static double _kelvinToCelsius(double kelvin) {
    return double.parse((kelvin - 273.15).toStringAsFixed(1));
  }
}
