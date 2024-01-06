import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app_2/controllers/TrendingController.dart';
import 'package:movie_app_2/screens/SearchScreen.dart';
import 'package:movie_app_2/screens/singleMediaScreen.dart';
import 'package:movie_app_2/utils/dataconstants.dart';

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
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                // overflow: Overflow.visible,
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
                        child: Container(),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                child: Text(
                                  "Welcome Back, User",
                                  style: GoogleFonts.quicksand(fontSize: 30),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                              },
                              child: TextField(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 20),
                                  hintText: "Search movie or show",
                                  hintStyle: GoogleFonts.lato(fontSize: 20),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                                },
                                maxLines: 1,
                                textAlignVertical: TextAlignVertical.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 500,
                                enlargeCenterPage: true,
                                enlargeFactor: 0.3,
                                initialPage: 0,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 10),
                                padEnds: false,
                                autoPlayAnimationDuration: const Duration(seconds: 2),
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
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SingleMediaScreen(id: i.id, mediaType: i.mediaType)),
                                          );
                                        },
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
                            mediaType: MediaType.MOVIE,
                          ),
                          const HorizontalScrollingDataWidget(
                            id: 2,
                            dataType: HorizontalScrollingDataType.topShow,
                            mediaType: MediaType.MOVIE,
                          ),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}
