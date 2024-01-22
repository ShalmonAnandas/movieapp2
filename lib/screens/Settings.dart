import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app_2/utils/dataconstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> list = <String>['VidSrc PRO', 'Superembed'];

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String dropdownValue = DataConstants.provider;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Provider",
                      style: GoogleFonts.quicksand(fontSize: 18),
                    ),
                    DropdownButton(
                      value: dropdownValue,
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.quicksand(),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        await pref.setString("provider", value!);
                        DataConstants.provider = value;
                        setState(() {
                          dropdownValue = value;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
