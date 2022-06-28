import 'dart:convert';

import 'package:flutter_app_summer_project/model/weather_model.dart';
import 'package:flutter_app_summer_project/util/weather_util.dart';
import 'package:http/http.dart';

class Network {
  //Method for getting weather information from the web api.
  Future<WeatherModel> getWeatherForecast({required String cityName}) async {
    var finalUrl =
        'https://api.weatherapi.com/v1/forecast.json?key=${WeatherUtil.apiKey}&q=$cityName&days=5&aqi=no&lang=fi';

    final response = await get((Uri.parse(finalUrl)));

    //Decode response to UTF8 to show special characters correctly.
    final decodedResponse = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      print('Weather response: $decodedResponse');
      return WeatherModel.fromJson(//Response parsed into a dart object.
          json.decode(decodedResponse));
    } else {
      throw Exception('Error getting weather forecast');
    }
  }
}
