import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Movie with ChangeNotifier {
  final int id;
  bool is_Adult;
  String imdb_id;
  String title;
  String original_language;
  String original_title;
  String overview;
  String poster_path;
  String backdrop_path;
  String release_date;
  int revenue;
  int runtime;
  String status;
  String tagline;
  var vote_average;
  int vote_count;
  List<String> backdrops;
  List<String> posters;
  List<String> videos;
  List<String>genres;

  Movie({
    this.id,
    this.imdb_id,
    this.title,
    this.tagline,
    this.overview,
    this.is_Adult,
    this.original_title,
    this.original_language,
    this.poster_path,
    this.backdrop_path,
    this.status,
    this.release_date,
    this.revenue,
    this.runtime,
    this.vote_average,
    this.vote_count,
    this.backdrops,
    this.posters,
    this.videos,
    this.genres,
  });
}
