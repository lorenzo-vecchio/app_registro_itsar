import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:prova_registro/globals.dart';
import 'homepage.dart';
import 'loginpage.dart';
import 'data.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Perform some initialization operations
    AndroidOptions getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    final username = await storage.read(key: 'username');
    final password = await storage.read(key: 'password');
    Data data = Data.fromDisc();
    try {
      await data.initialize();
      if (username != null && password != null && data.materieList.isNotEmpty) {
        globalData = data;
        alreadyHaveData = true;
      }
    } catch (e) {
      // Handle errors here
      print('Error during initialization: $e');
    }
    Future<bool> isNetworkAvailable() async {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      return true;
    }
    if(await isNetworkAvailable() && username != null && password != null) {
      data = Data.fromCredentials(username, password);
      await data.initialize();
      if(data.jsonString.isNotEmpty) {
        globalData = data;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
      FlutterNativeSplash.remove();
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: alreadyHaveData ? HomePage() : LoginPage(),
        theme: ThemeData(
          listTileTheme: ListTileThemeData(
            tileColor: Colors.grey.shade900.withOpacity(0.50),
            contentPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: Colors.grey.shade900.withOpacity(0.50),
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
            fillColor: Colors.grey.shade900.withOpacity(0.50),
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
}