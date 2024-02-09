import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:movie_app_2/controllers/TrendingController.dart';

class DataConstants {
  static final dio = Dio();
  static var trendingController = Get.put(TrendingController());
  static String provider = "";
  static String appBarTitle = "Welcome back, User";
}
