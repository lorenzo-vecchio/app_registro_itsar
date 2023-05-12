import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prova_registro/globals.dart';
import 'package:prova_registro/providers/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'homepage.dart';
import 'loginpage.dart';
import 'data.dart';
import 'notifi_service.dart';

const fetchBackground = "fetchBackground";

Future<dynamic> backgroundSync() async {
  // Code to run in background
  AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
  final username = await storage.read(key: 'username');
  final password = await storage.read(key: 'password');
  Data dataFromDisc = Data.fromDisc();
  try {
    dataFromDisc.initialize();
    Data dataFromApi = Data.fromCredentials(username!, password!);
    dataFromApi.initialize();
    // confront old data with new data to check for new grades
    Voto? newVoto = dataFromApi.checkGradesDifference(dataFromDisc);
    if (newVoto != null) {
      // notifica
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
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: const Color.fromRGBO(0, 0, 0, 0.5),
      statusBarBrightness: Brightness.dark,
    ),
  );
  // notifications
  NotificationService().initNotification();
  // background configuration android
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  if (Platform.isAndroid) {
    await Workmanager().registerPeriodicTask(
      "1",
      fetchBackground,
      frequency: const Duration(minutes: 15),
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

  runApp(const MyApp());
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
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // removes the splashscreen
      FlutterNativeSplash.remove();

      return ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(builder: (context, model, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: alreadyHaveData ? const HomePage() : const LoginPage(),
            theme: getThemeData(model.isDarkMode, Brightness.light),
            darkTheme: getThemeData(model.isDarkMode, Brightness.dark),
          );
        }),
      );
    }
  }
}

ThemeData getThemeData(bool isDarkMode, Brightness tema) {
  return ThemeData(
      scaffoldBackgroundColor:
          isDarkMode ? backgroundDarkMode : backgroundLightMode,
      brightness: tema,
      listTileTheme: ListTileThemeData(
        textColor: isDarkMode ? Colors.white : Colors.black,
        tileColor: isDarkMode ? tileBackgroundDarkMode : tileBackgoundLightMode,
        contentPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              backgroundColor: darkRedITS,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            backgroundColor: darkRedITS),
      ),
      inputDecorationTheme: InputDecorationTheme(
          labelStyle:
              TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          filled: true,
          fillColor: isDarkMode
              ? Colors.grey.shade900.withOpacity(0.50)
              : Colors.grey.shade400.withOpacity(0.50),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(500)),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: isDarkMode ? Colors.white : Colors.black),
            borderRadius: BorderRadius.circular(500),
          ),
          floatingLabelStyle:
              TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 72.0,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        titleLarge: TextStyle(
          fontSize: 36.0,
          fontStyle: FontStyle.italic,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Montserrat',
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        bodySmall: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        displaySmall: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        displayMedium: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        titleSmall: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        titleMedium: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        bodyLarge: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        headlineSmall: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        headlineMedium: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        headlineLarge: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        labelSmall: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        labelMedium: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        labelLarge: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ));
}
