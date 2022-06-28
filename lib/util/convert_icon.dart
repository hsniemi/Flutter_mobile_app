import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:universal_html/html.dart';

//Get the appropriate Font awesome icon based on weather description.
Widget getWeatherIcon(
    {String? weatherDescription, Color? color, double? size}) {
  switch (weatherDescription) {
    case "Aurinkoinen":
      {
        return Icon(
          FontAwesomeIcons.solidSun,
          color: color,
          size: size,
        );
      }

    case "Pilvetön":
      {
        return Icon(
          FontAwesomeIcons.moon,
          color: color,
          size: size,
        );
      }

    case "Puolipilvinen":
      {
        return Icon(
          FontAwesomeIcons.cloudSun,
          color: color,
          size: size,
        );
      }

    case "Hajanaista sadetta lähellä":
    case "Pilvinen":
    case "Täysin pilvinen":
      {
        return Icon(
          FontAwesomeIcons.cloud,
          color: color,
          size: size,
        );
      }

    case "Hajanainen kevyt sade":
    case "Kevyt sade":
    case "Kevyt tihkusade":
    case "Kevyt jäätävä sade":
    case "Jäätävä tihkusade":
    case "Rankka jäätävä tihkusade":
    case "Hajanainen kevyt tihkusade":
    case "Hajanaista jäätävää sadetta lähellä":
      {
        return Icon(
          FontAwesomeIcons.cloudRain,
          color: color,
          size: size,
        );
      }

    case "Keskivoimakas sade":
    case "Keskivoimakas tai rankka jäätävä sade":
    case "Rankka sadekuuro":
    case "Rankka sade":
      {
        return Icon(
          FontAwesomeIcons.cloudShowersHeavy,
          color: color,
          size: size,
        );
      }

    case "Ajoittainen rankka sade":
    case "Ajoittainen keskivoimakas sade":
    case "Kevyt sadekuuro":
    case "Keskivoimakas tai rankka sadekuuro":
      {
        return Icon(
          FontAwesomeIcons.cloudSunRain,
          color: color,
          size: size,
        );
      }

    case "Paikoittainen kevyt sade ukkosalueella":
    case "Keskivoimakas tai rankka sade ukkosalueella":
    case "Ukkospuuskia lähellä":
      {
        return Icon(
          FontAwesomeIcons.cloudBolt,
          color: color,
          size: size,
        );
      }

    case "Lumipuuska":
    case "Lumimyrsky":
    case "Hajanainen kevyt lumisade":
    case "Kevyt lumisade":
    case "Kevyt räntäsade":
    case "Keskivoimakas tai rankka räntäsade":
    case "Hajanainen keskivoimakas lumisade":
    case "Keskivoimakas lumisade":
    case "Ajoittainen rankka lumisade":
    case "Rankka lumisade":
    case "Kevyitä lumisadekuuroja":
    case "Hajanaista räntäsadetta lähellä":
    case "Kevyitä räntäsadekuuroja":
    case "Keskivoimakkaita tai rankkoja lumisadekuuroja":
    case "Keskivoimakkaita tai rankkoja räntäsadekuuroja":
    case "Paikoittainen kevyt lumisade ukkosalueella":
    case "Keskivoimakas tai rankka lumisade ukkosalueella":
    case "Hajanaista lumisadetta lähellä":
      {
        return Icon(
          FontAwesomeIcons.snowflake,
          color: color,
          size: size,
        );
      }

    case "Sumuinen":
    case "Jäätävä sumu":
    case "Sumu":
      {
        return Icon(
          FontAwesomeIcons.smog,
          color: color,
          size: size,
        );
      }

    default:
      {
        return Icon(
          FontAwesomeIcons.cloud,
          color: color,
          size: size,
        );
      }
  }
}

/*
all different weather descriptions from the api:

eng. / suom. 

Sunny, Clear(night) / Aurinkoinen, Pilvetön(yö)//
Partly Cloudy/ Puolipilvinen//
Cloudy / Pilvinen/
Overcast / Täysin pilvinen//
Mist/ Sumuinen//
Patchy rain nearby/ Hajanaista sadetta lähellä//
Patchy snow nearby / Hajanaista lumisadetta lähellä//
Patchy sleet nearby/ Hajanaista räntäsadetta lähellä//
Patchy freezing drizzle nearby / Hajanaista jäätävää sadetta lähellä//
Thundery outbreaks in nearby / Ukkospuuskia lähellä//
Blowing snow / Lumipuuska//
Blizzard / Lumimyrsky//
Fog / Sumu//
Freezing fog / Jäätävä sumu//
Patchy light drizzle / Hajanainen kevyt tihkusade//
Light drizzle / Kevyt tihkusade//
Freezing drizzle / Jäätävä tihkusade//
Heavy freezing drizzle / Rankka jäätävä tihkusade//
Patchy light rain / Hajanainen kevyt sade//
Light rain / Kevyt sade//
Moderate rain at times / Ajoittainen keskivoimakas sade//
Moderate rain / Keskivoimakas sade//
Heavy rain at times / Ajoittainen rankka sade//
Heavy rain /  Rankka sade//
Light freezing rain / Kevyt jäätävä sade//
Moderate or heavy freezing rain/ Keskivoimakas tai rankka jäätävä sade//
Light sleet / Kevyt räntäsade//
Moderate or heavy sleet / Keskivoimakas tai rankka räntäsade//
Patchy light snow / Hajanainen kevyt lumisade//
Light snow/ Kevyt lumisade//
Patchy moderate snow / Hajanainen keskivoimakas lumisade//
Moderate snow / Keskivoimakas lumisade//
Patchy heavy snow / Ajoittainen rankka lumisade//
Heavy snow/ Rankka lumisade//
Ice pellets / Rakeet//
Light rain shower / Kevyt sadekuuro//
Moderate or heavy rain shower / Keskivoimakas tai rankka sadekuuro//
Torrential rain shower / Rankka sadekuuro//
Light sleet showers / Kevyitä räntäsadekuuroja//
Moderate or heavy sleet showers / Keskivoimakkaita tai rankkoja räntäsadekuuroja//
Light snow showers / Kevyitä lumisadekuuroja//
Moderate or heavy snow showers / Keskivoimakkaita tai rankkoja lumisadekuuroja//
Light showers of ice pellets / Kevyitä raekuuroja
Moderate or heavy showers of ice pellets / Keskivoimakkaita tai rankkoja raekuuroja
Patchy light rain in area with thunder / Paikoittainen kevyt sade ukkosalueella //
Moderate or heavy rain in area with thunder / Keskivoimakas tai rankka sade ukkosalueella//
Patchy light snow in area with thunder / Paikoittainen kevyt lumisade ukkosalueella //
Moderate or heavy snow in area with thunder / Keskivoimakas tai rankka lumisade ukkosalueella //

*/