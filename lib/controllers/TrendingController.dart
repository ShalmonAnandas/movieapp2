import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:movie_app_2/models/trendingMovieModel.dart';
import 'package:movie_app_2/utils/dataconstants.dart';

class TrendingController extends GetxController {
  static RxBool isTrendingLoading = true.obs;
  static RxList<TrendingMovieModel> trendingData = <TrendingMovieModel>[].obs;
  static RxList<String> trendingPosterPath = <String>[].obs;

  getTrending(String mediaType) async {
    String? url;

    url = "https://api.themoviedb.org/3/trending/$mediaType/day?language=en-US";
    Map<String, String> headers = {
      "accept": "application/json",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4N2Q1NTg1YTU0OTdiMzczNjc5ZThiZGM3ZDZmMGQyMiIsInN1YiI6IjYyMWRlNjY2ZDM4YjU4MDAxYmY0NDM3NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.JQAtkdBkGc2UNLbGZltTqowTCKCRyoGFL1OkwuWTZz8"
    };
    isTrendingLoading(true);
    try {
      dio.Response response = await DataConstants.dio.get(url, options: dio.Options(headers: headers));
      List rawData = response.data["results"];

      for (var i = 0; i < rawData.length; i++) {
        trendingData.add(TrendingMovieModel.fromJson(rawData[i]));
      }
      dataParsing();
    } catch (e) {
      log("MainScreenError $e");
    } finally {
      isTrendingLoading(false);
    }
  }

  dataParsing() {
    for (var element in trendingData) {
      trendingPosterPath.add(element.posterPath);
    }
  }
}
