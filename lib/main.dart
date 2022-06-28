import 'package:flutter/material.dart';
import 'package:flutter_app_summer_project/providers/my_locations.dart';
import 'package:flutter_app_summer_project/providers/pickable_list_provider.dart';
import 'package:flutter_app_summer_project/themes/custom_theme.dart';
import 'package:flutter_app_summer_project/ui/home.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Declaring Providers in the runApp function.
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PickableListProvider()),
      ChangeNotifierProvider(create: (_) => MyLocations()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.customTheme, //Use custom theme in this app.
      home: PickableListView(), //Initial page/route of the app.
    ),
  ));
}
