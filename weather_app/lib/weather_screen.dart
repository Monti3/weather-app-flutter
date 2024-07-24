import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/key.dart';
import 'hourly_forecast_item.dart';
import 'additional_info_item.dart';
import 'package:http/http.dart' as http;

//
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  dynamic temp = 0;
  String city = 'quilmes,ar';
  @override
  void initState() {
    super.initState();
    weather = getWeather();
  }

  Future<Map<String, dynamic>> getWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&lang=es&APPID=$openWeatherAPIKey',
        ),
      );
      final data = jsonDecode(res.body);
      final dataCod = data['cod'];
      debugPrint('Data type: ${dataCod.runtimeType} \n dataCod: $dataCod');

      if (data['cod'] != '200') {
        throw 'Un error inesperado ocurrió: ${data['message']}';
      }

      return data;
    } catch (e) {
      throw (e.toString()); // recibe el error pero se continua corriend
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Climatix',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('rrerrrr');
              setState(() {
                weather = getWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final dataList = data['list'][0];
          final cTemp = dataList['main']['temp'];
          final cSky = (dataList['weather'][0]['main']);
          final cSkyDesc = (dataList['weather'][0]['description']);
          final cPressure = dataList['main']['pressure'];
          final cWind = dataList['wind']['speed'];
          final cHumidity = dataList['main']['humidity'];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // carta principal & ubicacion
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 32,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          Text(
                            '$cTemp °C',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 0),
                          Icon(
                            cSky == 'Clouds' || cSky == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            size: 52,
                          ),
                          Text(
                            cSkyDesc,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                const Text(
                  'Pronostico',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final fTime = '${hourlyForecast['dt_txt']}';
                      final time = DateTime.parse(fTime);
                      return HourlyForecastItem(
                          time: DateFormat.Hm().format(time),
                          icon: getWeatherIcon(
                              hourlyForecast['weather'][0]['main']),
                          temperature: '${hourlyForecast['main']['temp']} °C');
                    },
                  ),
                ),

                //info extra
                const SizedBox(height: 15),
                const Text(
                  'Información Extra',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: CupertinoIcons.wind,
                      title: 'Viento',
                      value: '${cWind} km/h',
                    ),
                    AdditionalInfoItem(
                      icon: CupertinoIcons.cloud_rain,
                      title: 'Humedad',
                      value: '${cHumidity} mm',
                    ),
                    AdditionalInfoItem(
                      icon: CupertinoIcons.airplane,
                      title: 'Presión',
                      value: '${cPressure} hPa',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
