import 'package:flutter/material.dart';

import '../model/weather_model.dart';
import 'forecast_card.dart';

/*
This class creates a horizontally scrollable row of 
weather cards for the days in the forecast.
*/

class BottomView extends StatelessWidget {
  const BottomView({Key? key, required this.snapshot}) : super(key: key);
  final AsyncSnapshot<WeatherModel> snapshot;

  @override
  Widget build(BuildContext context) {
    var forecastList = snapshot.data!.forecast!.forecastday;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Kolmen päivän ennuste'.toUpperCase(),
          style: Theme.of(context).textTheme.headline2,
        ),
        Container(
          height: 180,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemCount: forecastList!.length,
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                padding: const EdgeInsets.all(3),
                width: MediaQuery.of(context).size.width / 2.3,
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffe98fbe), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: forecastCard(
                    snapshot, index, context), //Creates the day card.
              ),
            ),
          ),
        ),
      ],
    );
  }
}
