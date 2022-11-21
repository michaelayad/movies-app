import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies_app/providers/movie_provider.dart';
import 'package:movies_app/ui/screens/youtube_player_screen.dart';
import 'package:movies_app/ui/widgets/switch_theme_button.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../providers/movies_provider.dart';
import '../../providers/darktheme_provider.dart';
import '../widgets/marquee.dart';

class MovieDetailsScreen extends StatefulWidget {
  static const routeName = "/movieDetailsScreen";

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool _showTrailer = false;
  YoutubePlayerController _youtubeController;

  @override
  void initState() {
    // TODO: implement initState
    _youtubeController = YoutubePlayerController(
      initialVideoId: "LTn3gkC5kkk",
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    );

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context).settings.arguments as int;
    final screenWidth = MediaQuery.of(context).size.width;
    final movie = Provider.of<Movies>(context).allMovies[id];
    var hieght = screenWidth * 1;
    final darkTHeme = Provider.of<DarkThemeProvider>(context).isDark;

    Widget ItemTitle(String text1) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          text1,
          style: TextStyle(
            fontSize: screenWidth < 400
                ? 24
                : screenWidth < 600
                    ? 30
                    : 35,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Color(0xff01b4e4),
                offset: Offset(-5, 5),
              ),
              Shadow(
                blurRadius: 10,
                color: Color(0xff90cea1),
                offset: Offset(5, 5),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: MarqueeWidget(
                child: Text(
                  movie.title,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              actions: [
                SwitchThemeButton(),
              ],
              expandedHeight: screenWidth * 1,
              centerTitle: true,
              //floating: true,
              primary: true,
              pinned: true,
              elevation: 30,
              //snap: true,

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
                child: FlexibleSpaceBar(
                  //centerTitle: true,

                  background: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          movie.poster_path,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        child: GestureDetector(
                          child: Chip(
                            label: Text(
                              "Trailer",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            avatar: Image.asset(
                              "assets/images/youtube1.png",
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                            ),
                            padding: EdgeInsets.all(8),
                            elevation: 20,
                          ),
                          onTap: () {
                            setState(() {
                              Navigator.of(context).pushNamed(
                                YoutubePlayerScreen.routeName,
                                arguments: [movie.id,0],
                              );
                            });
                          },
                        ),
                        right: 10,
                        bottom: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Release Date",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          movie.release_date,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "User Rating",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  ItemTitle("Gernes"),
                  Container(
                    height: 70,
                    width: screenWidth,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 1,
                        childAspectRatio: 1 / 3,
                      ),
                      itemBuilder: (ctx, index) {
                        return Container(
                          alignment: AlignmentDirectional.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xff3f72af),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: FittedBox(
                            child: Text(
                              movie.genres[index],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: movie.genres.length,
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                  Divider(),
                  ItemTitle("OverView"),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      movie.overview,
                      style: TextStyle(
                        fontSize: 18,
                        //   fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Divider(),
                  ItemTitle("BackDrops"),
                  InteractiveViewer(
                    minScale: 0.3,
                    //    constrained: false,
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.all(8),
                        height: 280,
                        width: screenWidth,
                        child: PageView.builder(
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(8),
                                  height: 280,
                                  width: screenWidth,
                                  child: Image.network(
                                    movie.backdrops[index],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  child: Chip(
                                    label: Text(
                                      "${index + 1}:${movie.backdrops.length}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: Colors.black45,
                                  ),
                                  top: 10,
                                  right: 10,
                                ),
                              ],
                            );
                          },
                          itemCount: movie.backdrops.length,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  ItemTitle("Posters"),
                  InteractiveViewer(
                    minScale: 0.3,
                    //    constrained: false,
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.all(8),
                        height: 350,
                        width: screenWidth,
                        child: PageView.builder(
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(8),
                                  height: 350,
                                  width: screenWidth,
                                  child: Image.network(
                                    movie.posters[index],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  child: Chip(
                                    label: Text(
                                      "${index + 1}:${movie.posters.length}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: Colors.black45,
                                  ),
                                  top: 10,
                                  right: 10,
                                ),
                              ],
                            );
                          },
                          itemCount: movie.posters.length,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
