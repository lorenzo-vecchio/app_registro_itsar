import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:prova_registro/pages/home.dart';
import 'package:prova_registro/pages/calendario.dart';
import 'package:prova_registro/pages/presenze.dart';
import 'package:prova_registro/pages/voti.dart';
import 'package:prova_registro/pages/account.dart';
import 'package:prova_registro/globals.dart';
import 'screen_size.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const Home(),
    const Voti(),
    const Calendario(),
    const Presenze(),
    const Account(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ScreenSize.init(context);
  }

  @override
  Widget build(BuildContext context) {
    // gets if it's in dark mode or not
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: isDarkMode
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: _pages[_selectedIndex]),
      bottomNavigationBar: Container(
        color: isDarkMode ? backgroundDarkMode : backgroundLightMode,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              ScreenSize.screenWidth * 0.025,
              ScreenSize.screenHeight * 0.025,
              ScreenSize.screenWidth * 0.025,
              ScreenSize.screenHeight * 0.05),
          child: GNav(
            backgroundColor: isDarkMode ? backgroundDarkMode : backgroundLightMode,
            color: isDarkMode ? notActiveTextDarkMode : notActiveTextLightMode,
            activeColor: isDarkMode ? activeTextDarkMode : activeTextLightMode,
            tabBackgroundColor: isDarkMode
                ? tabBackgroundColorDarkMode
                : tabBackgroundColorLightMode,
            padding: EdgeInsets.all(
              ScreenSize.screenWidth * 0.035,
            ),
            gap: ScreenSize.screenWidth * 0.02,
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(
                icon: Icons.calculate_outlined,
                text: 'Voti',
              ),
              GButton(
                icon: Icons.calendar_month_outlined,
                text: 'Calendario',
              ),
              GButton(
                icon: Icons.schedule,
                text: 'Presenze',
              ),
              GButton(
                icon: Icons.account_box_outlined,
                text: 'Account',
              )
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
