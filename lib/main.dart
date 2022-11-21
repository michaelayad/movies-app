import 'package:flutter/material.dart';
import 'package:movies_app/ui/screens/movie_details_screen.dart';
import 'package:movies_app/ui/screens/youtube_player_screen.dart';
import 'package:movies_app/utils/styles.dart';
import 'package:provider/provider.dart';
import './providers/darktheme_provider.dart';
import './providers/movie_provider.dart';
import './providers/movies_provider.dart';
import './providers/trending.dart';

import './ui/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider changeThemeProvider = DarkThemeProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getThemeProvider();
  }

  void getThemeProvider() async {
    changeThemeProvider.isDark =
        await changeThemeProvider.darkThemePreferences.getDarkTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: changeThemeProvider,
        ),
        ChangeNotifierProvider.value(
          value: Movies(),
        ),
        ChangeNotifierProvider.value(
          value: Trending(),
        ),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, darkThemeProvider, _) => MaterialApp(
          title: 'Movies App',
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(
            darkThemeProvider.isDark,
            context,
          ),
          home: HomeScreen(),
          routes: {
            MovieDetailsScreen.routeName: (ctx) => MovieDetailsScreen(),
            YoutubePlayerScreen.routeName: (ctx) => YoutubePlayerScreen(),
          },
        ),
      ),
    );
  }
}
