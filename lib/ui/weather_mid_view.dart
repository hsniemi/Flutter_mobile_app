import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_summer_project/themes/custom_theme.dart';
import 'package:flutter_app_summer_project/util/convert_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/weather_model.dart';
import '../util/weather_util.dart';

/*
This class creates the middle part of the weather view, 
containing the current weather information.
*/

class MidView extends StatelessWidget {
  const MidView({Key? key, required this.snapshot}) : super(key: key);
  final AsyncSnapshot<WeatherModel> snapshot;

  @override
  Widget build(BuildContext context) {
    var forecastList = snapshot.data!.forecast!.forecastday!;
    var current = snapshot.data!.current;

    var city = snapshot.data!.location!.name;
    var country = snapshot.data!.location!.country;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$city, $country',
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            WeatherUtil.getFormattedDate(
              DateTime.parse(forecastList[0].date!),
            ),
          ),
          //Alternative way of getting the date:
          // Text(WeatherUtil.getFormattedDate(DateTime.fromMillisecondsSinceEpoch(
          //     forecastList[0].dateEpoch! * 1000))),
          const SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: getWeatherIcon(
                weatherDescription: forecastList[0].day?.condition?.text,
                color: Colors.pinkAccent,
                size: 190),
          ),
          //Option to get the weather icon from the web using url from the api response.
          // Image.network(
          //   'https:${forecastList[0].day!.condition!.icon}',
          //   scale: 0.5,
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    '${current?.tempC?.toStringAsFixed(0)} °C ',
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        ?.copyWith(fontSize: 30),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Text(
                    '${forecastList[0].day?.condition?.text}'.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        ?.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 12.0),
                  child: Column(
                    children: [
                      Text(
                        '${current?.windKph} Km/h',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      const Icon(
                        FontAwesomeIcons.wind,
                        size: 20,
                        color: Colors.brown,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 12.0),
                  child: Column(
                    children: [
                      Text(
                        '${current?.humidity} %',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      const Icon(
                        FontAwesomeIcons.solidFaceGrinBeamSweat,
                        size: 20,
                        color: Colors.brown,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 12.0),
                  child: Column(
                    children: [
                      Text(
                        '${current?.feelslikeC?.toStringAsFixed(0)} °C', //alt + 0176
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      const Icon(
                        FontAwesomeIcons.person,
                        size: 20,
                        color: Colors.brown,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
