import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'globals.dart';

class Data {
  List<Voto> votiList = [];
  List<Materia> materieList = [];
  String jsonString = "";
  bool valid = false;
  int requestStatus = 0;
  String requestBody = "";
  String username;
  String password;
  bool fromCred;

  Data()
      : fromCred = false,
        password = "",
        username = "";
  Data.fromCredentials(this.username, this.password) : fromCred = true;
  Data.fromDisc()
      : fromCred = false,
        password = "",
        username = "";

  Future<void> initialize() async {
    if (fromCred) {
      await _APIconnection(username, password);
      jsonString = requestBody;
      if (requestStatus == 200) {
        _convertJSON();
        await _saveCredentials(username, password);
        await _saveDataToDisc();
      } else {
        valid = false;
      }
    } else {
      await _readDataFromDisc();
      _convertJSON();
    }
    globalData = this;
  }

  void _convertJSON() {
    valid = true;
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    jsonMap['voti'].forEach((key, value) {
      votiList.add(Voto(key, value));
    });
    jsonMap['calendario'].forEach((element) {
      String nomeMateria = element['title'];
      DateTime inizio = DateTime.parse(element['start']);
      DateTime fine = DateTime.parse(element['end']);
      int sede = int.parse(element['AltraSede']);
      String aula = element['aula'];
      Materia materia = Materia(sede, fine, inizio, nomeMateria, aula);
      materieList.add(materia);
    });
    materieList.sort((a, b) => a.inizio.compareTo(b.inizio));
  }

  Future<void> _APIconnection(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://flask-api-scraper.vercel.app'),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    requestStatus = response.statusCode;
    requestBody = response.body;
  }

  Future<void> _saveDataToDisc() async {
    final path = await getApplicationDocumentsDirectory();
    final file = File('${path.path}/data.json');
    await file.writeAsString(jsonString);
  }

  Future<void> _readDataFromDisc() async {
    final path = await getApplicationDocumentsDirectory();
    final file = File('${path.path}/data.json');
    final String content = await file.readAsString();
    jsonString = content;
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<void> _saveCredentials(String username, String password) async {
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    await storage.write(key: 'username', value: username);
    await storage.write(key: 'password', value: password);
  }
}

class Voto {
  String nomeMateria;
  int voto;

  Voto(this.nomeMateria, this.voto);
}

class Materia {
  int sede;
  DateTime fine;
  DateTime inizio;
  String nomeMateria;
  String aula;

  Materia(this.sede, this.fine, this.inizio, this.nomeMateria, this.aula);
}
