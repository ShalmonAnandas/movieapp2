import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:movie_app_2/utils/commonFunctions.dart';

import '../models/castModel.dart';
import '../models/movieOverviewModel.dart';
import '../models/showOverviewModel.dart';
import '../utils/enums.dart';

class HorizontalScrollingDataController {
  static List<MovieOverviewModel> topMovies = <MovieOverviewModel>[];
  static List<ShowOverviewModel> topShows = <ShowOverviewModel>[];
  static List<MovieOverviewModel> similarMovies = <MovieOverviewModel>[];
  static List<ShowOverviewModel> similarShows = <ShowOverviewModel>[];
  static List<CastModel> cast = <CastModel>[];

  static getTopMovieList() async {
    try {
      dio.Response response =
          await CommonFunctions.dioHttpPost("https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1");
      List rawData = response.data["results"];

      topMovies.clear();
      for (var i = 0; i < rawData.length; i++) {
        topMovies.add(MovieOverviewModel.fromJson(rawData[i]));
      }
    } catch (e) {
      log("topMovie Error $e");
    }
    return topMovies;
  }

  static getTopShowList() async {
    try {
      dio.Response response =
          await CommonFunctions.dioHttpPost("https://api.themoviedb.org/3/tv/top_rated?language=en-US&page=1");
      List rawData = response.data["results"];

      topShows.clear();
      for (var i = 0; i < rawData.length; i++) {
        topShows.add(ShowOverviewModel.fromJson(rawData[i]));
      }
    } catch (e) {
      log("topShow Error $e");
    }
    return topShows;
  }

  static getCast(int id, MediaType mediaType) async {
    try {
      dio.Response response = await CommonFunctions.dioHttpPost(
          "https://api.themoviedb.org/3/${mediaType == MediaType.movie ? "movie" : "tv"}/$id/credits?language=en-US");
      List rawData = response.data["cast"];

      cast.clear();
      for (var i = 0; i < rawData.length; i++) {
        cast.add(CastModel.fromJson(rawData[i]));
      }
    } catch (e) {
      log("cast Error $e");
    }
    return cast;
  }

  static getSimilarMovie(int id) async {
    try {
      dio.Response response =
          await CommonFunctions.dioHttpPost("https://api.themoviedb.org/3/movie/$id/similar?language=en-US&page=1");
      List rawData = response.data["results"];

      similarMovies.clear();
      for (var i = 0; i < rawData.length; i++) {
        similarMovies.add(MovieOverviewModel.fromJson(rawData[i]));
      }
    } catch (e) {
      log("similarMovies Error $e");
    }
    return similarMovies;
  }

  static getSimilarShow(int id) async {
    // try {
    dio.Response response =
        await CommonFunctions.dioHttpPost("https://api.themoviedb.org/3/tv/$id/similar?language=en-US&page=1");
    List rawData = response.data["results"];

    similarShows.clear();
    for (var i = 0; i < rawData.length; i++) {
      similarShows.add(ShowOverviewModel.fromJson(rawData[i]));
    }
    // } catch (e) {
    //   log("similarShows Error $e");
    // }
    return similarShows;
  }
}
