import 'package:LadyBug/Screens/loading_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.grey[200],
      tabBarTheme: TabBarTheme(
          labelColor: Colors.deepOrange[700],
          labelStyle: TextStyle(color: Colors.black),
          unselectedLabelColor: Colors.black),
      cardColor: Colors.grey[50],
      buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          disabledColor: Colors.grey[300],
          buttonColor: Colors.grey[200],
          textTheme: ButtonTextTheme.accent),
      buttonColor: Colors.deepOrange[700],
      primaryColor: Colors.black,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepOrange[700]),
      iconTheme: IconThemeData(color: Colors.black),
      primaryTextTheme: TextTheme(
        headline: TextStyle(
            fontSize: 64.32,
            fontFamily: 'Manjari',
            fontStyle: FontStyle.italic),
        title: TextStyle(
            fontSize: 22.0,
            fontFamily: 'Manjari',
            fontWeight: FontWeight.w700,
            color: Colors.black),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
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
      splashColor: Colors.deepOrange[400],
      dividerColor: Colors.black,
      disabledColor: Colors.grey[300],
      primaryIconTheme: IconThemeData(color: Colors.deepOrange[700]),
      secondaryHeaderColor: Colors.deepOrange[700],
      accentColor: Colors.black,
      appBarTheme: AppBarTheme(
          color: Colors.grey[50],
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
            title: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Manjari',
                fontWeight: FontWeight.w700,
                color: Colors.black),
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
