import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app_2/screens/singleMediaScreen.dart';
import 'package:movie_app_2/utils/enums.dart';
import 'package:movie_app_2/utils/getSearch.dart';

import '../models/searchResultsModel.dart';

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
      appBar: AppBar(
        title: Text(
          "Search",
          style: GoogleFonts.quicksand(),
        ),
      ),
      body: SafeArea(
        child: Column(
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
                  snapshot.data?.results.removeWhere((element) => element.mediaType == MediaType.PERSON);
                  children = Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.results.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleMediaScreen(
                                    id: snapshot.data!.results[index].id,
                                    mediaType: snapshot.data!.results[index].mediaType),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Row(
                                children: [
                                  Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: snapshot.data!.results[index].posterPath!.isEmpty
                                        ? Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                MediaQuery.of(context).size.width * 0.11,
                                                MediaQuery.of(context).size.height * 0.09,
                                                MediaQuery.of(context).size.width * 0.11,
                                                MediaQuery.of(context).size.height * 0.09),
                                            child: const Icon(
                                              Icons.broken_image,
                                              size: 70,
                                              color: Colors.white30,
                                            ),
                                          )
                                        : Image.network(
                                            'https://image.tmdb.org/t/p/w600_and_h900_bestv2${snapshot.data?.results[index].posterPath}',
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topCenter,
                                          ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 25),
                                          child: Text(
                                            snapshot.data!.results[index].name ?? snapshot.data!.results[index].title!,
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.quicksand(fontWeight: FontWeight.w600, fontSize: 18),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
                                          child: Text(
                                            snapshot.data!.results[index].overview!,
                                            softWrap: true,
                                            maxLines: 7,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.quicksand(fontWeight: FontWeight.w600, fontSize: 12),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
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
      ),
    );
  }
}
