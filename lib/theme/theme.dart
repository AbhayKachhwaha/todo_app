import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    background: Colors.grey.shade300,
    primary: Colors.grey.shade400,
    tertiary: Colors.black,
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    brightness: Brightness.dark,
    background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    tertiary: Colors.white,
  ),
);
