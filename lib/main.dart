import 'package:flutter/material.dart';
import 'loginpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      theme: ThemeData(
        listTileTheme: ListTileThemeData(
          tileColor: Colors.grey.shade900,
          contentPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              color: Colors.grey.shade800,
            ),
          ),
        ),
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFc00d0e)
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade900,
          ),
          // Define the default font family.
          fontFamily: 'Montserrat',

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            displayLarge:
                TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Montserrat'),
          ),
      ),

    );
  }
}
