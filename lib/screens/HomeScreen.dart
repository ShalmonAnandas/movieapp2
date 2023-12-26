import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:movie_app_2/controllers/TrendingController.dart';
import 'package:movie_app_2/screens/Placeholders.dart';
import 'package:movie_app_2/utils/dataconstants.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/enums.dart';
import '../widgets/HorizontalScrollingDataWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String trendingMovieTitle = "";
  String backdropPath = "";

  @override
  void initState() {
    DataConstants.trendingController.getTrending("all");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Obx(
      () {
        return TrendingController.isTrendingLoading.value == true
            ? Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: true,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const BannerPlaceholder(),
                      TitlePlaceholder(width: MediaQuery.of(context).size.width * 0.6),
                      const SizedBox(height: 16.0),
                      const ContentPlaceholder(
                        lineType: ContentLineType.threeLines,
                      ),
                      const SizedBox(height: 16.0),
                      const SizedBox(height: 16.0),
                      const ContentPlaceholder(
                        lineType: ContentLineType.twoLines,
                      ),
                      const SizedBox(height: 16.0),
                      const SizedBox(height: 16.0),
                      const ContentPlaceholder(
                        lineType: ContentLineType.twoLines,
                      ),
                      const SizedBox(height: 16.0),
                      const SizedBox(height: 16.0),
                      const ContentPlaceholder(
                        lineType: ContentLineType.twoLines,
                      ),
                      const SizedBox(height: 16.0),
                      const SizedBox(height: 16.0),
                      const ContentPlaceholder(
                        lineType: ContentLineType.twoLines,
                      ),
                      const SizedBox(height: 16.0),
                      const SizedBox(height: 16.0),
                      const ContentPlaceholder(
                        lineType: ContentLineType.twoLines,
                      ),
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1500),
                    child: Container(
                      key: ValueKey<String>(backdropPath),
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            backdropPath,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.transparent, Colors.black],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: 500,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,
                              initialPage: 0,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 5),
                              onPageChanged: (index, reason) {
                                setState(
                                  () {
                                    // trendingMovieTitle = TrendingController.trendingData[index].title;
                                    backdropPath =
                                        "https://image.tmdb.org/t/p/w600_and_h900_bestv2${TrendingController.trendingBackdropPath[index]}";
                                  },
                                );
                              },
                            ),
                            items: TrendingController.trendingData.map(
                              (i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width: width,
                                        // margin: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.0),
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              "https://image.tmdb.org/t/p/w600_and_h900_bestv2/${i.posterPath}",
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        const HorizontalScrollingDataWidget(
                          id: 1,
                          dataType: HorizontalScrollingDataType.topMovie,
                          mediaType: MediaType.movie,
                        ),
                        const HorizontalScrollingDataWidget(
                          id: 2,
                          dataType: HorizontalScrollingDataType.topShow,
                          mediaType: MediaType.movie,
                        ),
                      ],
                    ),
                  ),
                ],
              );
      },
    );
  }
}
