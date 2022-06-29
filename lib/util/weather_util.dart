import 'package:flutter_config/flutter_config.dart';
import 'package:intl/intl.dart';

/*
This class contains a helper method for formatting the date to for example: "Maanantai 20.06.22"
*/

class WeatherUtil {
  static String apiKey = FlutterConfig.get('WEATHER_API_KEY');

  static String getFormattedDate(DateTime dateTime) {
    String day = DateFormat('EEEE').format(dateTime);
    switch (day) {
      case 'Monday':
        {
          day = 'Maanantai';
        }
        break;
      case 'Tuesday':
        {
          day = 'Tiistai';
        }
        break;
      case 'Wednesday':
        {
          day = 'Keskiviikko';
        }
        break;
      case 'Thursday':
        {
          day = 'Torstai';
        }
        break;
      case 'Friday':
        {
          day = 'Perjantai';
        }
        break;
      case 'Saturday':
        {
          day = 'Lauantai';
        }
        break;
      case 'Sunday':
        {
          day = 'Sunnuntai';
        }
        break;
    }

    String date = DateFormat('dd.MM.yy').format(dateTime);
    return '$day $date';
  }
}
