import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;

  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 24,
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                time,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Icon(
                icon,
                size: 32,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                temperature,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData getWeatherIcon(dynamic wt) {
  debugPrint('wt:  fgfffffffffffffffffffffffffffffffffffffff $wt');
  if (wt == 'Clouds') {
    return Icons.wb_cloudy; // Icono para temperaturas frías
  } else if (wt == 'Rain') {
    return Icons.cloudy_snowing; // Icono para temperaturas templadas
  } else {
    return Icons.wb_sunny; // Icono para temperaturas cálidas
  }
}
