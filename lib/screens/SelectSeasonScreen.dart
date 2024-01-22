import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/showDetailModel.dart';

class SelectSeasonScreen extends StatefulWidget {
  const SelectSeasonScreen({super.key, required this.seasons, required this.showName});
  final List<Season> seasons;
  final String showName;

  @override
  State<SelectSeasonScreen> createState() => _SelectSeasonScreenState();
}

class _SelectSeasonScreenState extends State<SelectSeasonScreen> {
  late List<String> seasonList = widget.seasons.map((e) => e.name).toList();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.showName),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomDropdown<String>(
              overlayHeight: (MediaQuery.of(context).size.height * 0.05) * seasonList.length,
              decoration: CustomDropdownDecoration(
                closedFillColor: theme.cardColor,
                expandedFillColor: theme.cardColor,
                headerStyle: GoogleFonts.quicksand(),
                listItemStyle: GoogleFonts.quicksand(),
              ),
              hintText: 'Select Season',
              items: seasonList,
              initialItem: seasonList[seasonList.indexWhere((element) => element.contains("1"))],
              onChanged: (value) {
                log(seasonList.indexWhere((element) => element == value).toString());
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.builder(
              itemCount: widget.seasons.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Row(
                    children: [
                      Text(
                        widget.seasons[index].name,
                        style: GoogleFonts.quicksand(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
