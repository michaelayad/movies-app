import 'package:flutter/material.dart';
import 'package:movies_app/providers/movie_provider.dart';
import 'package:movies_app/ui/screens/movie_details_screen.dart';
import 'package:provider/provider.dart';
import './marquee.dart';

class MovieItem extends StatelessWidget {
  const MovieItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movie = Provider.of<Movie>(context);

    return LayoutBuilder(
      builder: (ctx, constrain) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              MovieDetailsScreen.routeName,
              arguments: movie.id,
            );
          },
          child: Stack(
            children: [
              Image.network(
                movie.poster_path,
                height: constrain.maxHeight * 0.75,
                fit: BoxFit.fitHeight,
              ),
              Positioned(
                  top: 3,
                  right: 3,
                  child: IconButton(
                      icon: Icon(Icons.menu, size: 35, color: Colors.white),
                      onPressed: () {})),
              Positioned(
                top: constrain.maxHeight * 0.75 - 30,
                left: 5,
                child: Chip(
                  avatar: Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  label: Text(movie.vote_average.toString()),
                  labelPadding: EdgeInsets.all(4),
                  backgroundColor: Color(0xff112d4e),
                  elevation: 10,
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: constrain.maxHeight * 0.75 + 20,
                left: 5,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LimitedBox(
                        maxWidth: constrain.maxHeight * 0.45,
                        child: MarqueeWidget(
                          child: Text(
                            movie.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        movie.release_date,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
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
