import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app_2/controllers/GenreController.dart';
import 'package:movie_app_2/screens/HomeScreen.dart';
import 'package:movie_app_2/screens/Settings.dart';
import 'package:movie_app_2/screens/underConstructionPage.dart';
import 'package:movie_app_2/utils/dataconstants.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> tabItems = [
    const HomeScreen(),
    const UnderConstruction(),
    const UnderConstruction(),
    const SettingScreen(),
  ];

  @override
  void initState() {
    GenreController.getGenres();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          DataConstants.appBarTitle,
          style: GoogleFonts.quicksand(fontSize: 30),
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        selectedItemColor: theme.colorScheme.secondary,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_outlined),
            title: Text(
              'Home',
              style: GoogleFonts.quicksand(),
            ),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.movie_creation_outlined),
            title: Text('Movies', style: GoogleFonts.quicksand()),
            // activeColor: Colors.white,
            // inactiveColor: Colors.white
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.tv_outlined),
            title: Text('TV Shows', style: GoogleFonts.quicksand()),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings_outlined),
            title: Text('Settings', style: GoogleFonts.quicksand()),
          ),
        ],
        onTap: (index) => setState(() {
          _selectedIndex = index;
          switch (_selectedIndex) {
            case 0:
              DataConstants.appBarTitle = "Welcome Back, User";
            case 1:
              DataConstants.appBarTitle = "Movies";
            case 2:
              DataConstants.appBarTitle = "TV";
            case 3:
              DataConstants.appBarTitle = "Settings";
          }
        }),
      ),
      body: tabItems[_selectedIndex],
    );
  }
}
