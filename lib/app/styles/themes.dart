import 'package:flutter/material.dart';

import '../shared/constants/constants.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
        titleMedium: TextStyle(
          color: ColorsConst.white100,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          color: ColorsConst.white100,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        displayLarge: TextStyle(
          color: ColorsConst.white100,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        displayMedium: TextStyle(
          color: ColorsConst.white100,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: ColorsConst.terciary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
        headlineMedium: TextStyle(
            color: ColorsConst.white100,
            fontSize: 40,
            fontWeight: FontWeight.w600)),
  );
}
