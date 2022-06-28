import 'package:flutter/material.dart';
import 'package:flutter_app_summer_project/db/pickable_database.dart';
import 'package:flutter_app_summer_project/model/weather_model.dart';
import 'package:flutter_app_summer_project/ui/weather_bottom_view.dart';

import '../model/city.dart';
import '../network.dart';
import '../themes/custom_theme.dart';
import 'weather_mid_view.dart';

/*
This class creates the overall weather route layout. 
Wheater data is fetched from Weather API service at https://www.weatherapi.com/
*/

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  Future<WeatherModel>? forecastObject;
  String _cityName = "";

  @override
  void initState() {
    super.initState();
    getCity();
  }

// Get city name from database and if city name exists get the forecast and
// store it into variable forecastObject.
  Future<void> getCity() async {
    try {
      City city = await PickableDatabase.instance.readCity();
      setState(() {
        _cityName = city.cityName;
        print(_cityName);
      });
      if (_cityName.isNotEmpty) {
        forecastObject = getWeather(cityName: _cityName);
      }
    } catch (e) {
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sää'),
      ),
      body: ListView(
        children: [
          textFieldView(),
          _cityName == ""
              ? Container(
                  height: 200,
                  child: const Center(
                    child: Text('Etsi säätiedot kaupungin nimellä.'),
                  ),
                )
              : Container(
                  child: FutureBuilder<WeatherModel>(
                    future: forecastObject,
                    builder: (BuildContext context,
                        AsyncSnapshot<WeatherModel> snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            MidView(
                                snapshot:
                                    snapshot), //Creates the current weather view
                            BottomView(
                                snapshot:
                                    snapshot), //Creates the three day forecast view
                          ],
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.purple,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                )
        ],
      ),
    );
  }

  Widget textFieldView() {
    return Container(
      child: TextField(
        style: CustomInputTheme.inputTextStyle(),
        cursorColor: Colors.purple,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Anna kaupunki',
          hintStyle: CustomInputTheme.inputTextStyle(),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.purple,
          ),
          enabledBorder: CustomInputTheme.border(borderRadius: 0.0),
          focusedBorder: CustomInputTheme.border(borderRadius: 0.0),
          contentPadding: const EdgeInsets.all(8.0),
        ),
        onSubmitted: (value) {
          setState(() {
            _cityName = value;

            forecastObject = getWeather(cityName: _cityName);
            updateCity(_cityName);
          });
        },
      ),
    );
  }

//Call getWeatherForecast method in Network class and pass the city name.
  Future<WeatherModel> getWeather({required String cityName}) =>
      Network().getWeatherForecast(cityName: cityName);

//Store the city name into database, so when the weather view is opened,
//it shows the weather forecast for the place that was last searched.
  void updateCity(String cityName) async {
    PickableDatabase.instance.updateCity(cityName);
  }
}
