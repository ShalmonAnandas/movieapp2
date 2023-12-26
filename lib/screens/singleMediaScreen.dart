import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app_2/utils/enums.dart';
import 'package:movie_app_2/widgets/HorizontalScrollingDataWidget.dart';

import '../models/movieDetailModel.dart';
import '../utils/getIndividual.dart';

class SingleMediaScreen extends StatefulWidget {
  final int id;
  final MediaType mediaType;

  const SingleMediaScreen({
    super.key,
    required this.id,
    required this.mediaType,
  });

  @override
  State<SingleMediaScreen> createState() => _SingleMediaScreenState();
}

class _SingleMediaScreenState extends State<SingleMediaScreen> {
  GetIndividual currentMediaDetailsObj = GetIndividual();
  MovieDetailModel? currentMovieModel;

  @override
  void initState() {
    super.initState();
  }

  getCurrentMediaModel() async {
    return await currentMediaDetailsObj.getIndividualDetails(widget.id, widget.mediaType);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentMediaModel(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            floatingActionButton: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87, Colors.black],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      // VidSrcExtractor.extract('https://vidsrc.me/embed/movie?tmdb=${snapshot.data!.id}').then(
                      //   (value) async {
                      //     if (value != null) {
                      //       print(value);
                      //       // if (platform.isAndroid) {
                      //       launchVLCDeepLink(value);
                      //       // }
                      //       // Navigator.push(
                      //       //   context,
                      //       //   MaterialPageRoute(
                      //       //     builder: (context) => VideoPlayer(
                      //       //       name: snapshot.data!.title,
                      //       //       url: value,
                      //       //     ),
                      //       //   ),
                      //       // );
                      //     } else {
                      //       Fluttertoast.showToast(msg: "NOT FOUND");
                      //     }
                      //   },
                      // );
                    },
                    child: Text(
                      "Watch Now",
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://image.tmdb.org/t/p/w600_and_h900_bestv2${snapshot.data?.posterPath}',
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
                      colors: [Colors.transparent, Colors.black],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 30,
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w600_and_h900_bestv2${snapshot.data?.posterPath}',
                              height: 400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Center(
                            child: Text(
                              widget.mediaType == MediaType.movie ? snapshot.data.title : snapshot.data.originalName,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Text(
                                "Synopsis",
                                style: GoogleFonts.quicksand(fontWeight: FontWeight.w400, fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, bottom: 10, right: 10),
                          child: Text(
                            snapshot.data?.overview ?? "{{overview}}",
                            style: GoogleFonts.quicksand(fontWeight: FontWeight.w400),
                          ),
                        ),
                        // SimilarMoviesWidget(id: widget.id, mediaType: "movie"),
                        // HorizontalScrollingDataWidget(
                        //   id: widget.id,
                        //   mediaType: HorizontalScrollingDataType.si,
                        // ),

                        HorizontalScrollingDataWidget(
                            id: widget.id,
                            dataType: (widget.mediaType == MediaType.movie)
                                ? HorizontalScrollingDataType.similarMovie
                                : HorizontalScrollingDataType.similarShow,
                            mediaType: widget.mediaType),
                        HorizontalScrollingDataWidget(
                          id: widget.id,
                          dataType: HorizontalScrollingDataType.cast,
                          mediaType: widget.mediaType,
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
