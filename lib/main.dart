import 'package:LadyBug/Screens/loading_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
    theme: ThemeData(
      tabBarTheme: TabBarTheme(
          labelColor: Colors.deepOrange[700],
          unselectedLabelColor: Colors.deepOrange[50]),
      cardColor: Colors.grey[50],
      buttonTheme: ButtonThemeData(
          disabledColor: Colors.grey[50],
          buttonColor: Colors.deepOrange[50],
          textTheme: ButtonTextTheme.accent),
      buttonColor: Colors.deepOrange[700],
      primaryColor: Colors.deepOrange[700],
      iconTheme: IconThemeData(color: Colors.deepOrange[700]),
      primaryTextTheme: TextTheme(
        headline: TextStyle(
            fontSize: 64.32,
            fontFamily: 'Manjari',
            fontStyle: FontStyle.italic),
        title: TextStyle(
            fontSize: 22.0,
            fontFamily: 'Manjari',
            fontWeight: FontWeight.w700,
            color: Colors.deepOrange[700]),
      ),
      chipTheme: ChipThemeData.fromDefaults(
         // brightness: Brightness.light,
          labelStyle: TextStyle(
              fontSize: 13.0,
              fontFamily: 'Segoeu',
              color: Colors.deepOrange[900]),
          primaryColor: Colors.deepOrange[900],
          secondaryColor: Colors.deepOrange[100]),
      indicatorColor: Colors.deepOrange[700],
      splashColor: Colors.deepOrange[50],
      dividerColor: Colors.deepOrange[700],
      disabledColor: Colors.deepOrange[100],
      primaryIconTheme: IconThemeData(color: Colors.deepOrange[700]),
      secondaryHeaderColor: Colors.deepOrange[700],
      accentColor: Colors.deepOrange[700],
      appBarTheme: AppBarTheme(
          color: Colors.grey[50],
          iconTheme: IconThemeData(color: Colors.deepOrange[700]),
          actionsIconTheme: IconThemeData(color: Colors.deepOrange[700]),
          textTheme: TextTheme(
            title: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Manjari',
                fontWeight: FontWeight.w700,
                color: Colors.deepOrange[700]),
          )),
      fontFamily: 'Segoeu',
      textTheme: TextTheme(
        headline: TextStyle(
            fontSize: 64.32,
            fontFamily: 'Manjari',
            fontStyle: FontStyle.italic),
        title: TextStyle(
            fontSize: 32.0, fontFamily: 'Segoeu', fontWeight: FontWeight.w700),
        caption: TextStyle(
            fontSize: 14.0, fontFamily: 'Segoeu', color: Colors.white),
        body1: TextStyle(fontSize: 14.0, fontFamily: 'Segoeu'),
        body2: TextStyle(fontSize: 12.0, fontFamily: 'Segoeu'),
      ),
    ),
    home: Loading()));
