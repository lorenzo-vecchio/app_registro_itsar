import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:prova_registro/pages/home.dart';
import 'package:prova_registro/pages/calendario.dart';
import 'package:prova_registro/pages/presenze.dart';
import 'package:prova_registro/pages/voti.dart';
import 'package:prova_registro/pages/account.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    Home(),
    Voti(),
    Calendario(),
    Presenze(),
    Account(),
  ];

  @override
  Widget build(BuildContext context) {
    // gets if it's in dark mode or not
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: isDarkMode
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: _pages[_selectedIndex]),
      bottomNavigationBar: Container(
        color: isDarkMode ? Colors.black : Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: _mediaQueryData.size.width * 0.025,
            horizontal: _mediaQueryData.size.width * 0.025,
          ),
          child: GNav(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            color: isDarkMode ? Colors.white : Colors.black,
            activeColor: isDarkMode ? Colors.white : Colors.black,
            tabBackgroundColor: isDarkMode
                ? Colors.grey.shade900.withOpacity(0.50)
                : Colors.grey.shade400.withOpacity(0.50),
            padding: EdgeInsets.all(
              _mediaQueryData.size.width * 0.035,
            ),
            gap: _mediaQueryData.size.width * 0.02,
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
