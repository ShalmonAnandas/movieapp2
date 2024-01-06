// To parse this JSON data, do
//
//     final trendingModel = trendingModelFromJson(jsonString);

import 'dart:convert';

import 'package:movie_app_2/utils/enums.dart';

TrendingModel trendingModelFromJson(String str) => TrendingModel.fromJson(json.decode(str));

String trendingModelToJson(TrendingModel data) => json.encode(data.toJson());

class TrendingModel {
  bool adult;
  String backdropPath;
  int id;
  String title;
  String originalLanguage;
  String originalTitle;
  String overview;
  String posterPath;
  MediaType mediaType;
  List<int> genreIds;
  double popularity;
  String releaseDate;
  bool video;
  double voteAverage;
  int voteCount;

  TrendingModel({
    required this.adult,
    required this.backdropPath,
    required this.id,
    required this.title,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.mediaType,
    required this.genreIds,
    required this.popularity,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory TrendingModel.fromJson(Map<String, dynamic> json) => TrendingModel(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        id: json["id"],
        title: json["title"] ?? json["name"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"] ?? json["original_name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        mediaType: json["media_type"] == "movie" ? MediaType.MOVIE : MediaType.TV,
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        popularity: json["popularity"]?.toDouble(),
        releaseDate: json["release_date"] ?? json["first_air_date"],
        video: json["video"] ?? false,
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "id": id,
        "title": title,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "poster_path": posterPath,
        "media_type": mediaType,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "popularity": popularity,
        "release_date": releaseDate,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}
