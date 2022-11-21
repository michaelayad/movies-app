import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/switch_theme_button.dart';
import '../../providers/darktheme_provider.dart';
import '../../providers/movies_provider.dart';
import '../widgets/marquee.dart';

class YoutubePlayerScreen extends StatefulWidget {
  YoutubePlayerScreen({Key key}) : super(key: key);
  static const routeName = "/youtubePlayerScreen";

  @override
  _YoutubePlayerScreenState createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  YoutubePlayerController _youtubeController;
  int videoIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void displayBottomSheet(
      BuildContext context, final darktheme, List videosId, int id) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Container(
            color: darktheme
                ? Colors.black.withOpacity(0.6)
                : Colors.blue[300].withOpacity(0.4),
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(
              child: ListView.builder(
                itemCount: videosId.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed(
                        YoutubePlayerScreen.routeName,
                        arguments: [id, index],
                      );
                    },
                    child: LayoutBuilder(
                      builder: (ctx, constrain) => Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: constrain.maxHeight * 0.60,
                              width: constrain.maxHeight * 0.60 * 1.25,
                              child: Stack(
                                children: [
                                  Image.network(
                                    "https://img.youtube.com/vi/${videosId[index]}/hqdefault.jpg",
                                    fit: BoxFit.cover,
                                    height: constrain.maxHeight * 0.60,
                                    width: constrain.maxHeight * 0.60 * 1.25,
                                  ),
                                  Positioned(
                                    child: Icon(
                                      Icons.play_circle_outline,
                                      size: 40,
                                    ),
                                    top: (constrain.maxHeight * 0.30) - 20,
                                    left: (constrain.maxHeight * 0.30 * 1.25) -
                                        20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: constrain.maxHeight * 0.25,
                              width: constrain.maxHeight * 0.60 * 1.25,
                              child: SingleChildScrollView(
                                child: Text(
                                  "title of video is here",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print(videoIndex);
    final darkTHeme = Provider.of<DarkThemeProvider>(context).isDark;
    final arg = ModalRoute.of(context).settings.arguments as List<dynamic>;
    final movie = Provider.of<Movies>(context).allMovies[arg[0]];
    videoIndex = arg[1];
    return Scaffold(
      appBar: AppBar(
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
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dy < -20) {
            displayBottomSheet(context, darkTHeme, movie.videos, movie.id);
          }
        },
        child: Center(
          child: Stack(
            children: [
              Image.network(
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? movie.poster_path
                    : movie.backdrop_path,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
                fit: BoxFit.cover,
              ),
              Container(
                color: darkTHeme
                    ? Colors.black.withOpacity(0.8)
                    : Colors.blue[300].withOpacity(0.4),
              ),
              Center(
                child: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: movie.videos[videoIndex],
                    flags: YoutubePlayerFlags(
                      autoPlay: false,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                ),
              ),
              Positioned(
                bottom: 15,
                right: 15,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          width: 3,
                          color: darkTHeme ? Colors.white : Colors.black)),
                  child: FlatButton.icon(
                    onPressed: () {
                      displayBottomSheet(
                          context, darkTHeme, movie.videos, movie.id);
                    },
                    icon: Icon(
                      Icons.arrow_drop_up,
                      size: 35,
                    ),
                    label: Text(
                      "Show more",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
