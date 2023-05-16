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

class _AccountState extends State<Account> with WidgetsBindingObserver {
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final model = Provider.of<ThemeModel>(context, listen: false);
    if (model.systemTheme) {
      model.chooseTheme(
          true); // Imposta il tema di sistema solo se il tile è attivo
    }
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Consumer<ThemeModel>(builder: (context, model, child) {
      print(model.isDarkMode);
      return Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(ScreenSize.padding20,
                      ScreenSize.screenHeight * 0.07, 0, ScreenSize.padding20),
                  child: Text(
                    'Impostazioni',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Tema'),
              children: [
                SwitchListTile(
                  activeColor: Colors.green,
                  inactiveTrackColor: darkRedITS,
                  tileColor: Colors.transparent,
                  title: Text(
                    'Usa tema di sistema',
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
                  padding: EdgeInsets.fromLTRB(0, 0, 0, ScreenSize.padding20),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: ScreenSize.padding10),
                        child: Text('Cambia tema:'),
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
                          model.isDarkMode
                              ? Icons.wb_sunny
                              : Icons.nightlight_round,
                          color: model.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ExpansionTile(
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              title: Text('Account'),
              children: [
                SizedBox(
                  height: 0,
                  width: ScreenSize.screenWidth,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Il tuo account attuale è: ${globalData.username}',
                    style: TextStyle(
                      fontSize: 16,
                      color: model.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      ScreenSize.padding8, 0, 0, ScreenSize.padding20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200.0)),
                      backgroundColor: darkRedITS,
                    ),
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
