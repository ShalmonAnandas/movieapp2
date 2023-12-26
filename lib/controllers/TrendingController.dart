import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:movie_app_2/models/TrendingModel.dart';
import 'package:movie_app_2/utils/commonFunctions.dart';

class TrendingController extends GetxController {
  static RxBool isTrendingLoading = true.obs;
  static RxList<TrendingModel> trendingData = <TrendingModel>[].obs;

  static RxList<String> trendingPosterPath = <String>[].obs;
  static RxList<String> trendingBackdropPath = <String>[].obs;

  getTrending(String mediaType) async {
    isTrendingLoading(true);
    try {
      dio.Response response =
          await CommonFunctions.dioHttpPost("https://api.themoviedb.org/3/trending/$mediaType/day?language=en-US");
      List rawData = response.data["results"];

      // log(jsonEncode(rawData));

      trendingData.clear();
      for (var i = 0; i < rawData.length; i++) {
        trendingData.add(TrendingModel.fromJson(rawData[i]));
      }

      dataParsing();
    } catch (e) {
      log("Trending Controller Error $e");
    } finally {
      isTrendingLoading(false);
    }
  }

  dataParsing() {
    trendingPosterPath.clear();
    trendingBackdropPath.clear();
    for (var element in trendingData) {
      trendingPosterPath.add(element.posterPath);
      trendingBackdropPath.add(element.backdropPath);
    }
  }
}
