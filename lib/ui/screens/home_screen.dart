import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trending.dart';
import '../widgets/movie_item.dart';
import '../widgets/switch_theme_button.dart';
import '../../providers/movies_provider.dart';
import '../../providers/movie_provider.dart';
import '../../providers/darktheme_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isLoading = false;
  var init = true;
  int timeWindow = 0;
  Future _moviesFuture;
  Future fetchAllItems() {
    return Provider.of<Movies>(
      context,
      listen: false,
    ).fetchAndSetPopularMovies().then((_) {
      return Provider.of<Trending>(
        context,
        listen: false,
      ).fetchAndSetTrend();
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    _moviesFuture = fetchAllItems();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final movies = Provider.of<Movies>(
      context,
      listen: false,
    );
    final trending = Provider.of<Trending>(
      context,
      listen: false,
    );
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    final darkTHeme = Provider.of<DarkThemeProvider>(context).isDark;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.cover,
          width: screenWidth < 400
              ? 140
              : screenWidth < 600
                  ? 200
                  : 300,
        ),
        actions: [
          SwitchThemeButton(),
        ],
        flexibleSpace: Container(
          decoration: darkTHeme
              ? null
              : BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff112d4e),
                      Color(0xff3f72af),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
        ),
      ),
      body: FutureBuilder(
        future: _moviesFuture,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Popular",
                        style: TextStyle(
                          fontSize: screenWidth < 400
                              ? 24
                              : screenWidth < 600
                                  ? 30
                                  : 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: screenheight < 500
                      ? 300
                      : screenheight < 700
                          ? 400
                          : 500,
                  child: ListView.separated(
                    itemCount: movies.popularMovies.length > 20
                        ? 20
                        : movies.popularMovies.length,
                    itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                      value: movies.popularMovies[index],
                      child: Container(
                        child: MovieItem(),
                      ),
                    ),
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(15),
                    separatorBuilder: (ctx, ind) => SizedBox(
                      width: 20,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Trending",
                        style: TextStyle(
                          fontSize: screenWidth < 400
                              ? 24
                              : screenWidth < 600
                                  ? 30
                                  : 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 150,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  timeWindow = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: timeWindow == 0
                                      ? Theme.of(context).primaryColor
                                      : null,
                                ),
                                width: 75,
                                height: 40,
                                child: Text(
                                  "Day",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: timeWindow == 0
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  timeWindow = 1;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: timeWindow == 1
                                      ? Theme.of(context).primaryColor
                                      : null,
                                ),
                                width: 75,
                                height: 40,
                                child: Text(
                                  "Week",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: timeWindow == 1
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: screenheight < 500
                      ? 300
                      : screenheight < 700
                          ? 400
                          : 500,
                  child: ListView.separated(
                    itemCount: timeWindow == 0
                        ? (trending.dayMovieTrend.length > 20
                            ? 20
                            : trending.dayMovieTrend.length)
                        : (trending.weekMovieTrend.length > 20
                            ? 20
                            : trending.weekMovieTrend.length),
                    itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                      value: timeWindow == 0
                          ? trending.dayMovieTrend[index]
                          : trending.weekMovieTrend[index],
                      child: Container(
                        child: MovieItem(),
                      ),
                    ),
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(15),
                    separatorBuilder: (ctx, ind) => SizedBox(
                      width: 20,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
