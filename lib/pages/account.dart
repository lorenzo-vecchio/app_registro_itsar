import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import '../loginpage.dart';

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

  Future<void> _getUsername() async {
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    String? username = await storage.read(key: 'username');
    if (username != null) {
      Username = username;
    } else {
      Username = 'errore';
    }
  }

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                vertical: _mediaQueryData.size.height / 6,
                horizontal: _mediaQueryData.size.width),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Il tuo account attuale è:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${Username}',
              style: TextStyle(fontSize: 16),
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
                  builder: (BuildContext context) => LoginPage(),
                ),
                (route) => false,
              );
              setState(() {
                _isLoading = false;
              });
            },
            child: _isLoading ? CircularProgressIndicator() : Text('Logout'),
          ),
        ],
      ),
    );
  }
}
