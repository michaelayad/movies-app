import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/providers/movie_provider.dart';

class Trending with ChangeNotifier {
  List<Movie> _dayMovieTrend = [];
  List<Movie> _weekMovieTrend = [];

  List<Movie> get dayMovieTrend {
    return _dayMovieTrend;
  }

  List<Movie> get weekMovieTrend {
    return _weekMovieTrend;
  }

  Future<void> fetchAndSetTrend() async {
    var url =
        "https://api.themoviedb.org/3/trending/movie/day?api_key=3c95ad8a8edb6ecf8245db74e056344e";
    final responseDayMovie = await http.get(url);
    final extrackedDayMovies =
        json.decode(responseDayMovie.body)["results"] as List<dynamic>;
    url =
        "https://api.themoviedb.org/3/trending/movie/week?api_key=3c95ad8a8edb6ecf8245db74e056344e";
    final responseWeekMovie = await http.get(url);

    final extrackedWeekMovies =
        json.decode(responseWeekMovie.body)["results"] as List<dynamic>;
    List<Movie> _dayMovies = [];
    List<Movie> _weekMovies = [];
    extrackedDayMovies.forEach((e) {
      _dayMovies.add(Movie(
        vote_count: e["vote_count"],
        poster_path: "https://image.tmdb.org/t/p/w500${e["poster_path"]}",
        id: e["id"],
        is_Adult: e["adult"],
        backdrop_path: e["backdrop_path"],
        original_language: e["original_language"],
        original_title: e["original_title"],
        title: e["title"],
        vote_average: e["vote_average"],
        overview: e["overview"],
        release_date: e["release_date"],
      ));
    });
    extrackedWeekMovies.forEach((e) {
      _weekMovies.insert(
          0,
          Movie(
            vote_count: e["vote_count"],
            poster_path: "https://image.tmdb.org/t/p/w500${e["poster_path"]}",
            id: e["id"],
            is_Adult: e["adult"],
            backdrop_path: e["backdrop_path"],
            original_language: e["original_language"],
            original_title: e["original_title"],
            title: e["title"],
            vote_average: e["vote_average"],
            overview: e["overview"],
            release_date: e["release_date"],
          ));
    });
    _dayMovieTrend = _dayMovies;
    _weekMovieTrend = _weekMovies;

    notifyListeners();
  }
}
