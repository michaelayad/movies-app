import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../providers/darktheme_provider.dart';

class SwitchThemeButton extends StatelessWidget {
  const SwitchThemeButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final darkTHeme = Provider.of<DarkThemeProvider>(context);
    return Container(
      child: IconButton(
        icon: darkTHeme.isDark
            ? Icon(
                Icons.wb_sunny,
                color: Colors.white,
              )
            : Icon(
                Icons.brightness_2,
                color: Colors.white,
              ),
        onPressed: () {
          darkTHeme.isDark = !darkTHeme.isDark;
        },
      ),
    );
  }
}
