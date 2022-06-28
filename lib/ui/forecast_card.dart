import 'package:flutter/material.dart';
import 'package:flutter_app_summer_project/util/convert_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/weather_model.dart';
import '../util/weather_util.dart';

Widget forecastCard(AsyncSnapshot<WeatherModel> snapshot, index, context) {
  var forecastList = snapshot.data!.forecast!.forecastday;
  var dayOfWeek = "";
  var fullDate = WeatherUtil.getFormattedDate(
      DateTime.fromMillisecondsSinceEpoch(
          forecastList![index].dateEpoch! * 1000));

  dayOfWeek = fullDate.split(" ")[0];

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            dayOfWeek,
            style:
                Theme.of(context).textTheme.headline1!.copyWith(fontSize: 22),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue[100],
            child: getWeatherIcon(
              weatherDescription: forecastList[index].day!.condition!.text,
              color: Colors.pinkAccent,
              size: 40,
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.temperatureArrowUp,
                    size: 17,
                    color: Colors.brown,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${forecastList[index].day?.maxtempC} °C',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.temperatureArrowDown,
                    size: 17,
                    color: Colors.brown,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${forecastList[index].day?.mintempC} °C',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Icon(
                    forecastList[index].day?.dailyChanceOfSnow == 0 &&
                            forecastList[index].day!.avgtempC! > 0
                        ? FontAwesomeIcons.droplet
                        : FontAwesomeIcons.snowflake,
                    size: 17,
                    color: Colors.brown,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    forecastList[index].day?.dailyChanceOfSnow == 0
                        ? '${forecastList[index].day?.dailyChanceOfRain} %'
                        : '${forecastList[index].day?.dailyChanceOfSnow} %',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.wind,
                    size: 17,
                    color: Colors.brown,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${forecastList[index].day?.maxwindKph} Km/h',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ],
          ),
        ],
      )
    ],
  );
}
