import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prova_registro/globals.dart';
import 'package:workmanager/workmanager.dart';
import 'homepage.dart';
import 'loginpage.dart';
import 'data.dart';
import 'dart:ui' as ui;
import 'notifi_service.dart';
import 'package:notification_permissions/notification_permissions.dart';

const fetchBackground = "fetchBackground";

Future<dynamic> backgroundSync() async {
  // Code to run in background
  AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
  final username = await storage.read(key: 'username');
  final password = await storage.read(key: 'password');
  Data data_from_disc = Data.fromDisc();
  try {
    data_from_disc.initialize();
    Data data_from_API = Data.fromCredentials(username!, password!);
    data_from_API.initialize();
    // confront old data with new data to check for new grades
    Voto? newVoto = data_from_API.checkGradesDifference(data_from_disc);
    if (newVoto != null) {
      // da aggiungere notifica
      NotificationService().showNotification(
          title: 'ITSAR',
          body: 'Hai un nuovo voto: ${newVoto.voto} in ${newVoto.nomeMateria}');
    }
  } catch (e) {
    return false;
  }
  return true;
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        await backgroundSync();
        break;
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // keeps the splash screen until startup operations are finished
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // allow notifications
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  // notifications
  NotificationService().initNotification();
  // background configuration android
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  if (Platform.isAndroid) {
    await Workmanager().registerPeriodicTask(
      "1",
      fetchBackground,
      frequency: Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
  if (Platform.isIOS) {
    // background configuration ios
    // Register the background task method
    const backgroundTaskChannel =
        MethodChannel('com.example.myapp/background_task');
    backgroundTaskChannel.setMethodCallHandler((call) => backgroundSync());
  }

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
    }
    Future<bool> isNetworkAvailable() async {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      return true;
    }

    if (await isNetworkAvailable() && username != null && password != null) {
      data = Data.fromCredentials(username, password);
      await data.initialize();
      if (data.jsonString.isNotEmpty) {
        globalData = data;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = ui.window.platformBrightness;
    final isDarkMode = brightness == ui.Brightness.dark;
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // removes the splashscreen
      FlutterNativeSplash.remove();
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: alreadyHaveData ? HomePage() : LoginPage(),
        theme: ThemeData(
          listTileTheme: ListTileThemeData(
            tileColor: Colors.grey.shade300.withOpacity(0.50),
            contentPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: isDarkMode ? Colors.black : Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFc00d0e)),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: isDarkMode
                ? Colors.grey.shade900.withOpacity(0.50)
                : Colors.grey.shade400.withOpacity(0.50),
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
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          listTileTheme: ListTileThemeData(
            tileColor: Colors.grey.shade900.withOpacity(0.50),
            contentPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      );
    }
  }
}
