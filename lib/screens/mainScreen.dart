import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app_2/controllers/GenreController.dart';
import 'package:movie_app_2/screens/HomeScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> tabItems = [
    const HomeScreen(),
    const Center(child: Text("Movies")),
    const Center(child: Text("TV Shows")),
    const Center(child: Text("Settings")),
  ];

  @override
  void initState() {
    GenreController.getGenres();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: Text(
      //     "Trending Today",
      //     style: GoogleFonts.quicksand(fontWeight: FontWeight.w400),
      //   ),
      // ),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home_outlined),
            title: Text('Trending', style: GoogleFonts.quicksand()),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.movie_creation_outlined),
            title: Text('Movies', style: GoogleFonts.quicksand()),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.tv_outlined),
            title: Text('TV Shows', style: GoogleFonts.quicksand()),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.settings_outlined),
            title: Text('Settings', style: GoogleFonts.quicksand()),
          ),
        ],
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
      ),
      body: tabItems[_selectedIndex],
    );
  }
}
