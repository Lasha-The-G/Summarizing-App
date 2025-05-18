import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:perspicacity/note_page.dart';
import 'package:perspicacity/text_page.dart';

class MainMobile extends StatefulWidget {
  const MainMobile({super.key});

  @override
  State<MainMobile> createState() => _MainMobileState();
}

class _MainMobileState extends State<MainMobile> {
  int currentPageIndex = 0;
  final List<Widget> _pages = [TextPage(), ListWihParts()];

  void _navigateBottomBar(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        color: Color(0xff252523),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GNav(
            mainAxisAlignment: MainAxisAlignment.center,
            padding: EdgeInsets.all(17),
            gap: 8,
            color: Color(0xffa6a39a),
            activeColor: Color(0xffd0cfcb),
            backgroundColor: Color(0xff252523),
            selectedIndex: currentPageIndex,
            onTabChange: _navigateBottomBar,
            tabBackgroundColor: Color(0xff242321),
            tabActiveBorder: Border.all(
              width: .5,
              color: Color(0xffd0cfcb),
            ),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'TEXT',
              ),
              GButton(
                icon: Icons.note_add,
                text: 'NOTES',
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xff292927),
      body: _pages[currentPageIndex],
    );
  }
}
