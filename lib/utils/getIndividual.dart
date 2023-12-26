import 'dart:developer';

import 'package:dio/dio.dart' as dio;

import '../models/movieDetailModel.dart';
import '../models/showDetailModel.dart';
import 'commonFunctions.dart';
import 'enums.dart';

class GetIndividual {
  getIndividualDetails(int id, MediaType mediaType) async {
    print(id);
    try {
      dio.Response response = await CommonFunctions.dioHttpPost(
          "https://api.themoviedb.org/3/${(mediaType == MediaType.movie) ? "movie" : "tv"}/$id?language=en-US");
      var rawData = response.data;
      log(rawData.toString());

      ShowDetailModel? tvModel;
      MovieDetailModel? movieModel;

      if (mediaType == MediaType.movie) {
        movieModel = MovieDetailModel.fromJson(rawData);
        return movieModel;
      } else if (mediaType == MediaType.show) {
        tvModel = ShowDetailModel.fromJson(rawData);
        return tvModel;
      }
    } catch (e) {
      print("Get individual error $e");
    }
  }
}
