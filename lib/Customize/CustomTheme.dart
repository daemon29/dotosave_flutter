import 'package:flutter/material.dart';

class CustomTheme {
  final themData = new ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: Colors.lightBlue[800],
    accentColor: Colors.cyan[900],

    // Define the default font family.
    fontFamily: 'Segoeu',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline: TextStyle(
          fontSize: 64.32,
          fontFamily: 'Manjari',
          fontStyle: FontStyle.italic),
      title: TextStyle(
          fontSize: 32.0,
          fontFamily: 'Segoeu',
          fontWeight: FontWeight.w700),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Segoeu'),
      body2: TextStyle(fontSize: 12.0, fontFamily: 'Segoeu'),
    ),
  );
}
