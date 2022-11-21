import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './movie_provider.dart';

class Movies with ChangeNotifier {
  List<Movie> _popularMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _upComingMovies = [];
  Map<int, Movie> _allMovies = {};

  int _popularPage = 1;
  int _popularTotalPage = 1;

  List<Movie> get popularMovies {
    return _popularMovies;
  }

  List<Movie> get nowPlayingMovies {
    return _nowPlayingMovies;
  }

  List<Movie> get topRatedMovies {
    return _topRatedMovies;
  }

  Map<int, Movie> get allMovies {
    return _allMovies;
  }

  List<Movie> get upComingMovies {
    return _upComingMovies;
  }

  Future<void> fetchAndSetPopularMovies() async {
    if (_popularPage <= _popularTotalPage) {
      var url =
          "https://api.themoviedb.org/3/movie/popular?api_key=3c95ad8a8edb6ecf8245db74e056344e&language=en-US&page=${_popularPage.toString()}";
      try {
        final response = await http.get(
          url,
        );
        final extractedAllMovies = json.decode(
          response.body,
        );
        final extractedMovies = extractedAllMovies["results"] as List<dynamic>;
        _popularTotalPage = extractedAllMovies["total_pages"];
        //print(extractedMovies);
        extractedMovies.forEach((e) async {
          final newMovie = Movie(
            vote_count: e["vote_count"],
            poster_path: "https://image.tmdb.org/t/p/w500${e["poster_path"]}",
            id: e["id"],
            is_Adult: e["adult"],
            backdrop_path:
                "https://image.tmdb.org/t/p/w500${e["backdrop_path"]}",
            original_language: e["original_language"],
            original_title: e["original_title"],
            title: e["title"],
            vote_average: e["vote_average"],
            overview: e["overview"],
            release_date: e["release_date"],
            backdrops: [],
            genres: [],
            posters: [],
            videos: [],
          );

          _popularMovies.add(newMovie);
          if (!_allMovies.containsKey(e["id"])) {
            //  print("xxx");
            _allMovies[e["id"]] = newMovie;
            fetchMovieDetailsById(e["id"]);

            // print(_allMovies[e["id"]].id);
          }
        });
        notifyListeners();
      } catch (error) {
        throw error;
      }
      _popularPage++;
    }
  }

  Future<void> fetchMovieDetailsById(int id) async {
    List<String> backdrops = [];
    List<String> posters = [];
    List<String> videos = [];
    List<String> gernes = [];
    try {
      var url =
          "https://api.themoviedb.org/3/movie/${id}/images?api_key=3c95ad8a8edb6ecf8245db74e056344e&language=en-US&include_image_language=en,null";

      final movieResponse = await http.get(
        url,
      );
      final movieExtractedimages = json.decode(
        movieResponse.body,
      );

      final movieBackdrops = movieExtractedimages["backdrops"] as List<dynamic>;
      movieBackdrops.forEach((element) {
        backdrops.add("https://image.tmdb.org/t/p/w500${element["file_path"]}");
      });
      final moviePosters = movieExtractedimages["posters"] as List<dynamic>;
      moviePosters.forEach((element) {
        posters.add("https://image.tmdb.org/t/p/w500${element["file_path"]}");
      });
      url =
          "https://api.themoviedb.org/3/movie/${id}/videos?api_key=3c95ad8a8edb6ecf8245db74e056344e&language=en-US";
      final movieResponse2 = await http.get(
        url,
      );
      final movieExtractedVideos = json.decode(
        movieResponse2.body,
      )["results"] as List<dynamic>;
      movieExtractedVideos.forEach((element) {
        if (element["site"] == "YouTube") {
          videos.add(element["key"]);
        }
      });
      url =
          "https://api.themoviedb.org/3/movie/${id}?api_key=3c95ad8a8edb6ecf8245db74e056344e&language=en-US";
      final movieResponse3 = await http.get(
        url,
      );
      final movieExtractedGernes = json.decode(
        movieResponse3.body,
      )["genres"] as List<dynamic>;
      movieExtractedGernes.forEach((element) {
        gernes.add(element["name"]);
        print(element["name"]);
      });
      _allMovies[id].genres = gernes;
      _allMovies[id].posters = posters;
      _allMovies[id].backdrops = backdrops;
      _allMovies[id].videos = videos;
      notifyListeners();
    } catch (error) {}
  }
}
