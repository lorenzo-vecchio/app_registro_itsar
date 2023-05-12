import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prova_registro/screen_size.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../loginpage.dart';
import '../globals.dart';
import '../providers/themeProvider.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _isLoading = false;
  String Username = '';

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<void> _logout() async {
    final path = await getApplicationDocumentsDirectory();
    final file = File('${path.path}/data.json');
    await file.writeAsString('');
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    await storage.delete(key: 'username');
    await storage.delete(key: 'password');
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Consumer<ThemeModel>(builder: (context, model, child) {
      print(model.isDarkMode);
      return Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: mediaQueryData.size.height / 6,
                horizontal: mediaQueryData.size.width,
              ),
            ),
            FloatingActionButton(
              backgroundColor: darkRedITS,
              onPressed: () {
                if (model.systemTheme) {
                  print("Sono impostato su sistema");
                } else {
                  model.toggleTheme();
                }
              },
              child: Icon(
                model.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                color: model.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(
              height: ScreenSize.padding8,
            ),
            SwitchListTile(
              activeColor: Colors.blueAccent,
              inactiveTrackColor: darkRedITS,
              title: Text(
                'Usa tema del sistema',
                style: TextStyle(
                  color: model.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              value: model.systemTheme,
              onChanged: (bool value) {
                model.chooseTheme(value);
                print(model.isDarkMode);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Il tuo account attuale è:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: model.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                globalData.username,
                style: TextStyle(
                  fontSize: 16,
                  color: model.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await _logout();
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => const LoginPage(),
                  ),
                  (route) => false,
                );
                setState(() {
                  _isLoading = false;
                });
              },
              child: _isLoading
                  ? CircularProgressIndicator(
                      color: darkRedITS,
                    )
                  : Text(
                      'Logout',
                      style: TextStyle(
                        color: model.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}
