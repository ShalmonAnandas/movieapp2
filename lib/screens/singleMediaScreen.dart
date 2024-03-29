import 'dart:ui';

import 'package:external_video_player_launcher/external_video_player_launcher.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app_2/screens/SelectSeasonScreen.dart';
import 'package:movie_app_2/utils/dataconstants.dart';
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

  Future<String> getVideoLink() async {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/loading.json'),
            Text(
              "Fetching Link, Please be patient",
              style: GoogleFonts.quicksand(),
            )
          ],
        ),
      ),
    );
    var link = "";
    if (widget.mediaType == MediaType.MOVIE) {
      var response = await DataConstants.dio.request('https://vidsrc.applikuapp.com/movie/${widget.id}/${DataConstants.provider}');
      link = response.data["movie_link"];
    } else {
      var response = await DataConstants.dio.request('https://vidsrc.applikuapp.com/tv/${widget.id}/1/1/${DataConstants.provider}');
      link = response.data["show_link"];
    }
    return link;
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
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (widget.mediaType == MediaType.MOVIE) {
                      getVideoLink().then(
                        (link) {
                          Navigator.pop(context);
                          ExternalVideoPlayerLauncher.launchMxPlayer(link, MIME.applicationMp4, {"title": snapshot.data.title});
                        },
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectSeasonScreen(
                            seasons: snapshot.data.seasons,
                            showName: snapshot.data.originalName,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    (widget.mediaType == MediaType.MOVIE) ? "Watch Now" : "Select Season",
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.w400, fontSize: 20),
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
                    'https://image.tmdb.org/t/p/w600_and_h900_bestv2${snapshot.data?.backdropPath}',
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
                              widget.mediaType == MediaType.MOVIE ? snapshot.data.title : snapshot.data.originalName,
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
                        HorizontalScrollingDataWidget(
                            id: widget.id,
                            dataType: (widget.mediaType == MediaType.MOVIE)
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
