import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app_2/controllers/TrendingController.dart';
import 'package:movie_app_2/screens/Placeholders.dart';
import 'package:movie_app_2/utils/dataconstants.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String trendingMovieTitle = "";

  @override
  void initState() {
    DataConstants.trendingController.getTrending("movie");
    trendingMovieTitle = TrendingController.trendingData[0].title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Obx(() {
      if (TrendingController.isTrendingLoading.value == true) {
        return Shimmer.fromColors(
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
        );
      } else {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                    height: 500,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.2,
                    initialPage: 0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        trendingMovieTitle = TrendingController.trendingData[index].title;
                      });
                    }),
                items: TrendingController.trendingData.map((i) {
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
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  trendingMovieTitle,
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ListView.builder(
                  itemCount: TrendingController.trendingData.length,
                  itemBuilder: (context, index) {
                    return const Placeholder();
                  }),
            ],
          ),
        );
      }
    });
  }
}
