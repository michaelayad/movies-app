import 'package:flutter/cupertino.dart';
import 'package:movies_app/utils/darktheme_preferences.dart';
import '../utils/darktheme_preferences.dart';


class DarkThemeProvider with ChangeNotifier{

  DarkThemePreferences darkThemePreferences = DarkThemePreferences();
  bool _isDark=false;


  bool get isDark{
    return _isDark;
  }
  set isDark(bool value){
    darkThemePreferences.setDarkTheme(value);
    _isDark=value;
    notifyListeners();
  }

}