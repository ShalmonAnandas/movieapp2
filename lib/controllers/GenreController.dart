import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:movie_app_2/utils/commonFunctions.dart';

import '../models/GenreModel.dart';

class GenreController {
  static List<Genre> movieGenres = <Genre>[];
  static List<Genre> tvGenres = <Genre>[];

  static getGenres() async {
    try {
      dio.Response response =
          await CommonFunctions.dioHttpPost("https://api.themoviedb.org/3/genre/tv/list?language=en");
      List rawData = response.data["genres"];

      for (var i = 0; i < rawData.length; i++) {
        movieGenres.add(Genre.fromJson(rawData[i]));
      }
    } catch (e) {
      log("Genre Error $e");
    }
  }
}
