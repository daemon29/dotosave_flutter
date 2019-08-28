import 'package:LadyBug/Customize/colors.dart';
import 'package:flutter/material.dart';

import 'Customize/colors.dart';

final ThemeData _kLadybugTheme = _buildLadybugTheme();

ThemeData _buildLadybugTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      accentColor: kLadybug900,
      primaryColor: kLadybug100,
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: kLadybug100,
        textTheme: ButtonTextTheme.normal,
      ),
      scaffoldBackgroundColor: kLadybugBackgroundWhite,
      cardColor: kLadybugBackgroundWhite,
      errorColor: kLadybugErrorRed);
}
