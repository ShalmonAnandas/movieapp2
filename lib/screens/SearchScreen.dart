import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app_2/screens/singleMediaScreen.dart';
import 'package:movie_app_2/utils/getSearch.dart';

import '../models/searchResultsModel.dart';
import '../utils/enums.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FocusNode _focusNode = FocusNode();
  GetSearch getSearchObj = GetSearch();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setFocusOnPageInit();
  }

  void _setFocusOnPageInit() {
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  Future<SearchResults> getSearchResults() async {
    return getSearchObj.getSearch(searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              focusNode: _focusNode,
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  getSearchResults();
                });
              },
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
              maxLines: 1,
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
          FutureBuilder<SearchResults>(
            future: getSearchResults(),
            builder: (BuildContext context, AsyncSnapshot<SearchResults> snapshot) {
              Widget children;
              if (snapshot.hasData) {
                children = SizedBox(
                  height: MediaQuery.of(context).size.height * 0.770,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.65),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.results.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          if (snapshot.data?.results[index].mediaType.toString().toLowerCase() == "mediatype.movie") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingleMediaScreen(
                                      id: snapshot.data!.results[index].id, mediaType: MediaType.MOVIE)),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingleMediaScreen(
                                      id: snapshot.data!.results[index].id, mediaType: MediaType.MOVIE)),
                            );
                          }
                        },
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w600_and_h900_bestv2${snapshot.data?.results[index].posterPath}',
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                children = SizedBox(
                  height: MediaQuery.of(context).size.height * 0.770,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return children;
            },
          )
        ],
      ),
    );
  }
}
