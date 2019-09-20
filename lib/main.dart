import 'package:LadyBug/Screens/loading_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'Segoeu',
      textTheme: TextTheme(
        headline: TextStyle(
            fontSize: 64.32,
            fontFamily: 'Manjari',
            fontStyle: FontStyle.italic),
        title: TextStyle(
            fontSize: 32.0, fontFamily: 'Segoeu', fontWeight: FontWeight.w700),
        body1: TextStyle(fontSize: 14.0, fontFamily: 'Segoeu'),
        body2: TextStyle(fontSize: 12.0, fontFamily: 'Segoeu'),
      ),
    ),
    home: Loading()));
