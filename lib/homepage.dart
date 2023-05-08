import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:prova_registro/pages/home.dart';
import 'package:prova_registro/pages/calendario.dart';
import 'package:prova_registro/pages/presenze.dart';
import 'package:prova_registro/pages/voti.dart';
import 'package:prova_registro/pages/account.dart';
import 'package:prova_registro/globals.dart';
import 'package:prova_registro/providers/themeProvider.dart';
import 'package:provider/provider.dart';

import 'screen_size.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    ScreenSize.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ThemeModel>(); // definizione di model

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        color: model.isDarkMode ? backgroundDarkMode : backgroundLightMode,
        child: Padding(
          padding: EdgeInsets.fromLTRB(ScreenSize.padding10,
              ScreenSize.padding10, ScreenSize.padding10, ScreenSize.padding20),
          child: GNav(
            backgroundColor:
                model.isDarkMode ? backgroundDarkMode : backgroundLightMode,
            color: model.isDarkMode
                ? notActiveTextDarkMode
                : notActiveTextLightMode,
            activeColor:
                model.isDarkMode ? activeTextDarkMode : activeTextLightMode,
            tabBackgroundColor: model.isDarkMode
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
