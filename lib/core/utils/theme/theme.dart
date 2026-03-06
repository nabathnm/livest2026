import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';

class LivestAppTheme {
  LivestAppTheme._();

  static ThemeData theme = ThemeData(
    primaryColor: LivestColors.primaryNormal,
    fontFamily: 'PlusJakartaSans',

    scaffoldBackgroundColor: LivestColors.baseWhite,

    colorScheme: ColorScheme.fromSeed(
      seedColor: LivestColors.primaryNormal,
      background: LivestColors.baseWhite,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: LivestColors.baseWhite,
      elevation: 0,
    ),

    canvasColor: LivestColors.baseWhite,
  );
}
