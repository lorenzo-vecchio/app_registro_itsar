import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prova_registro/homepage.dart';
import 'package:prova_registro/data.dart';
import 'package:prova_registro/globals.dart';
import 'package:provider/provider.dart';
import '../providers/themeProvider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Data data = Data.fromCredentials(
          _usernameController.text, _passwordController.text);
      await data.initialize();
      setState(() => _isLoading = false);
      if (data.valid) {
        // Redirect to HomePage
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const HomePage(),
          ),
          (route) => false,
        );
      } else {
        // Show error popup
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Login failed. Please check your credentials.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // gets if it's in dark mode or not
    return Consumer<ThemeModel>(builder: (context, model, child) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Image(
                            image: model.isDarkMode
                                ? const AssetImage(
                                    'lib/assets/ITS-Logo-Negativo.png')
                                : const AssetImage(
                                    'lib/assets/ITS-Logo-Positivo-Login.png')),
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
                      const SizedBox(height: 16),
                      _isLoading
                          ? CircularProgressIndicator(
                              color: darkRedITS,
                            )
                          : SizedBox(
                              width: 100,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(70.0),
                                  )),
                                ),
                                child: const Text('Login'),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
