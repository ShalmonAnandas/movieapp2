import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/horizontalScrollingDataController.dart';
import '../screens/singleMediaScreen.dart';
import '../utils/enums.dart';

class HorizontalScrollingDataWidget extends StatefulWidget {
  final int id;
  final HorizontalScrollingDataType dataType;
  final MediaType mediaType;

  const HorizontalScrollingDataWidget({
    super.key,
    required this.id,
    required this.dataType,
    required this.mediaType,
  });

  @override
  State<HorizontalScrollingDataWidget> createState() => _HorizontalScrollingDataWidgetState();
}

class _HorizontalScrollingDataWidgetState extends State<HorizontalScrollingDataWidget> {
  var future;
  late String bottomText;
  late String imagePath;

  @override
  void initState() {
    switch (widget.dataType) {
      case HorizontalScrollingDataType.topMovie:
        future = HorizontalScrollingDataController.getTopMovieList();
      case HorizontalScrollingDataType.topShow:
        future = HorizontalScrollingDataController.getTopShowList();
      case HorizontalScrollingDataType.cast:
        future = HorizontalScrollingDataController.getCast(widget.id, widget.mediaType);
      case HorizontalScrollingDataType.similarMovie:
        future = HorizontalScrollingDataController.getSimilarMovie(widget.id);
      case HorizontalScrollingDataType.similarShow:
        future = HorizontalScrollingDataController.getSimilarShow(widget.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Text(
              (widget.dataType == HorizontalScrollingDataType.topShow)
                  ? "Top Rated Shows"
                  : (widget.dataType == HorizontalScrollingDataType.topMovie)
                      ? "Top Rated Movies"
                      : (widget.dataType == HorizontalScrollingDataType.cast)
                          ? "Cast"
                          : (widget.dataType == HorizontalScrollingDataType.similarMovie)
                              ? "Similar Movies"
                              : (widget.dataType == HorizontalScrollingDataType.similarShow)
                                  ? "Similar Shows"
                                  : "",
              style: GoogleFonts.quicksand(fontWeight: FontWeight.w400, fontSize: 24),
            ),
          ],
        ),
      ),
      FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget children;
          if (snapshot.hasData) {
            children = SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  switch (widget.dataType) {
                    case HorizontalScrollingDataType.topMovie:
                      bottomText = snapshot.data[index].title;
                      imagePath = snapshot.data[index].posterPath;
                    case HorizontalScrollingDataType.topShow:
                      bottomText = snapshot.data[index].originalName;
                      imagePath = snapshot.data[index].posterPath;
                    case HorizontalScrollingDataType.cast:
                      bottomText = snapshot.data[index].name;
                      imagePath = snapshot.data[index].profilePath;
                    case HorizontalScrollingDataType.similarMovie:
                      bottomText = snapshot.data[index].title;
                      imagePath = snapshot.data[index].posterPath;
                    case HorizontalScrollingDataType.similarShow:
                      bottomText = snapshot.data[index].originalName;
                      imagePath = snapshot.data[index].posterPath ?? "";
                  }
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () {
                        switch (widget.dataType) {
                          case HorizontalScrollingDataType.topMovie:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleMediaScreen(
                                  id: snapshot.data[index].id,
                                  mediaType: MediaType.movie,
                                ),
                              ),
                            );
                          case HorizontalScrollingDataType.topShow:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleMediaScreen(
                                  id: snapshot.data[index].id,
                                  mediaType: MediaType.show,
                                ),
                              ),
                            );
                          case HorizontalScrollingDataType.cast:
                          // TODO: Handle this case.
                          case HorizontalScrollingDataType.similarMovie:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleMediaScreen(
                                  id: snapshot.data[index].id,
                                  mediaType: MediaType.movie,
                                ),
                              ),
                            );
                          case HorizontalScrollingDataType.similarShow:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleMediaScreen(
                                  id: snapshot.data[index].id,
                                  mediaType: MediaType.movie,
                                ),
                              ),
                            );
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: NetworkImage(
                                (imagePath != "")
                                    ? 'https://image.tmdb.org/t/p/w600_and_h900_bestv2$imagePath'
                                    : "https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg",
                              ),
                              fit: BoxFit.cover),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.27,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.transparent, Colors.black],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                bottomText,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(fontWeight: FontWeight.w400, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            children = SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return children;
        },
      ),
    ]);
  }
}
