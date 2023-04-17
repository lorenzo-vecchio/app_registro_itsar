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
    return Scaffold(
      body: Center(
        child: ElevatedButton(
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
      ),
    );
  }
}
