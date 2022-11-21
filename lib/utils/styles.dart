import 'dart:ui';
import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDark, BuildContext context) {
    return ThemeData(
      primaryColor: isDark ? Colors.black : Color(0xff112d4e),
      accentColor: isDark ? Color(0xff3f72af) : Color(0xffdbe2ef),
      backgroundColor: isDark ? Colors.black : Color(0xffF1F5FB),
      canvasColor: isDark ? Color(0xff1f1e1e) : Colors.grey[50],
      brightness: isDark ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(
        elevation: 15,
      ),
    );
  }
}
