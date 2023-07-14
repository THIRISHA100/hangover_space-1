

import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor:Colors.transparent,
  ),
  colorScheme: ColorScheme.light(
    background: Colors.grey[300]!,
    primary: Colors.white!,
    secondary: Colors.grey[300]!

  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.black),
  ),


);