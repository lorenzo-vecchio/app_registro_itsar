import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prova_registro/homepage.dart';
import 'package:prova_registro/data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _storage = FlutterSecureStorage();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final response = await http.post(
        Uri.parse('https://web-production-ca2c.up.railway.app'),
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      setState(() => _isLoading = false);
      Data data = Data.fromJson(response.body);
      data.saveData();
      if (response.statusCode == 200) {
        // Store username and password securely
        await _storage.write(key: 'username', value: _usernameController.text);
        await _storage.write(key: 'password', value: _passwordController.text);
        // Redirect to HomePage
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => HomePage(),
          ),
          (route) => false,
        );
      } else {
        // Show error popup
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Login failed. Please check your credentials.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final username = await _storage.read(key: 'username');
    final password = await _storage.read(key: 'password');
    if (username != null && password != null) {
      setState(() {
        _usernameController.text = username;
        _passwordController.text = password;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Image(image: AssetImage('lib/assets/ITS-Logo-Negativo.png')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(70.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(70.0),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                _isLoading
                    ? CircularProgressIndicator()
                    : Container(
                  width: 100,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(70.0),
                            )),
                          ),
                          child: Text('Login'),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
