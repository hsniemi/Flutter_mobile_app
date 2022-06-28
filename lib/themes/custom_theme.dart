import 'package:flutter/material.dart';

//Color.fromARGB(255, 212, 194, 201)

CustomTheme theme = CustomTheme();
final colorPrimary = Colors.green[200];

const colorSecondary = Color.fromARGB(255, 226, 209, 210);

class CustomTheme {
  ThemeData get customTheme {
    final ThemeData theme = ThemeData();
    return theme.copyWith(
        primaryColor: colorPrimary,
        colorScheme: theme.colorScheme.copyWith(secondary: colorSecondary),
        scaffoldBackgroundColor: colorSecondary,
        appBarTheme: theme.appBarTheme.copyWith(
          backgroundColor: colorPrimary,
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: "Courgette",
            color: Colors.purple,
          ),
          iconTheme: const IconThemeData(
            color: Colors.purple,
            size: 34.0,
          ),
        ),
        textTheme: _appTextTheme(theme.textTheme),
        cardTheme: CardTheme(
          color: Colors.amber[100],
          shadowColor: Colors.purple,
          elevation: 6.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.pink[100],
          elevation: 6.5,
          // ignore: prefer_const_constructors
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: "Courgette",
            color: Colors.purple[800],
          ),
          contentTextStyle: TextStyle(
            fontSize: 18,
            color: Colors.purple[800],
            fontFamily: "Courgette",
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.purple,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            primary: colorPrimary,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "Ubuntu",
            ),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.purple,
        ));
  }
}

TextTheme _appTextTheme(TextTheme base) {
  return base.copyWith(
    headline1: base.headline1?.copyWith(
      color: Colors.purple,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Courgette",
    ),
    headline2: base.headline2?.copyWith(
      color: Colors.purple,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: "Ubuntu",
    ),
    bodyText1: base.bodyText1?.copyWith(
      color: Colors.red,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Courgette",
    ),
    bodyText2: base.bodyText2?.copyWith(
      color: Colors.purpleAccent,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Courgette",
    ),
    subtitle1: base.subtitle1?.copyWith(
      color: Colors.purple,
      fontSize: 16.0,
      fontFamily: "Ubuntu",
    ),
    subtitle2: base.subtitle2?.copyWith(
      color: Colors.purple,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      fontFamily: "Ubuntu",
    ),
  );
}

class CustomInputTheme {
  static TextStyle inputTextStyle(
      {Color color = Colors.purple,
      double size = 18.0,
      String font = "Ubuntu"}) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontFamily: font,
    );
  }

  static OutlineInputBorder border(
      {Color color = Colors.purple,
      double width = 1.0,
      double borderRadius = 10.0}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
}
