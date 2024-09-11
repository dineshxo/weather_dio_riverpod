import 'package:flutter/material.dart';

class MainWeatherContainer extends StatelessWidget {
  final String location;
  final String temperature;
  final String description;
  final String feelsLike;
  final String imgPath;

  const MainWeatherContainer({
    super.key,
    required this.location,
    required this.temperature,
    required this.description,
    required this.feelsLike,
    required this.imgPath,
  });

  LinearGradient _getGradient(double temp) {
    if (temp < 15) {
      return LinearGradient(
        colors: [Colors.blue.shade400, Colors.blue.shade900],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (temp >= 15 && temp <= 30) {
      return LinearGradient(
        colors: [Colors.green.shade300, Colors.green.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return LinearGradient(
        colors: [Colors.orange.shade300, Colors.red.shade600],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final double temp = double.tryParse(temperature) ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(5),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: _getGradient(temp),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
           BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 4.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location,
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    Text(
                      '$temperature°C',
                      style: const TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Feels like $feelsLike°C',
                      style: TextStyle(
                        fontSize: 14.0,

                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    Text(
                      description,
                      style:const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset('images/weather_images/${imgPath.replaceAll('n', 'd')}.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
