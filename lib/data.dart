import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'globals.dart';
import 'package:intl/intl.dart';

class Data {
  List<Voto> votiList = [];
  List<Materia> materieList = [];
  List<PresenzaAssenza> presenzeList = [];
  String jsonString = "";
  bool valid = false;
  int requestStatus = 0;
  String requestBody = "";
  String username;
  String password;
  bool fromCred;
  Map<String, int> sommaPresenzeAssenze = {};

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
      final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
      username = await storage.read(key: 'username') ?? 'errore';
      password = await storage.read(key: 'password') ?? 'errore';
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
      bool esame = false;
      String nomeMateria = element['title'];
      DateTime inizio = DateTime.parse(element['start']);
      DateTime fine = DateTime.parse(element['end']);
      int sede = int.parse(element['AltraSede']);
      String aula = element['aula'];
      if (nomeMateria.contains('ESAME')) {
        esame = true;
      }
      Materia materia = Materia(sede, fine, inizio, nomeMateria, aula, esame);
      materieList.add(materia);
    });
    materieList.sort((a, b) => a.inizio.compareTo(b.inizio));
    jsonMap['presenze_assenze'].forEach((element) {
      String materia = element['materia'];
      double presenza = element['ore_presenza'];
      double assenza = element['ore_assenza'];
      int orePresenza = presenza.floor();
      int minutiPresenza = ((presenza - orePresenza) * 100).toInt();
      int oreAssenza = assenza.floor();
      int minutiAssenza = ((assenza - oreAssenza) * 100).toInt();
      DateTime data = DateTime.parse(
          element['date'].replaceAll('/', '-').split('-').reversed.join());
      DateTime inizio = DateFormat('HH:mm').parse(element['ora_inizio']);
      DateTime fine = DateFormat('HH:mm').parse(element['ora_fine']);
      PresenzaAssenza presAss = PresenzaAssenza(materia, orePresenza,
          minutiPresenza, oreAssenza, minutiAssenza, data, inizio, fine);
      presenzeList.add(presAss);
    });
    _getSommaPresenzeAssenze();
  }

  Future<void> _APIconnection(String username, String password) async {
    final response = await http.post(
      Uri.parse(
          'https://flask-api-registro-itsar-test-2anni.vercel.app'), //vercel contenente due anni ITSAR fatto da gio
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

  Voto? checkGradesDifference(Data oldData) {
    Data newData = this;

    // Create a map of all the grades in oldData, with the nomeMateria field as the key
    Map<String, Voto> oldGrades = {
      for (var v in oldData.votiList) v.nomeMateria: v
    };

    // Check if each grade in newData is already in oldGrades, comparing the nomeMateria field
    for (Voto newGrade in newData.votiList) {
      Voto? oldGrade = oldGrades[newGrade.nomeMateria];
      if (oldGrade == null || oldGrade.voto != newGrade.voto) {
        // If a new grade is found or the grade has changed, return it
        return newGrade;
      }
    }
    // If no new grades are found, return null
    return null;
  }

  void _getSommaPresenzeAssenze() {
    int oreP = 0;
    int minutiP = 0;
    int oreA = 0;
    int minutiA = 0;
    for (PresenzaAssenza item in presenzeList) {
      oreP = oreP + item.ore_presenza;
      minutiP = minutiP + item.minuti_presenza;
      oreA = oreA + item.ore_assenza;
      minutiA = minutiA + item.minuti_assenza;
    }
    oreP = oreP + (minutiP ~/ 60);
    minutiP = minutiP % 60;
    oreA = oreA + (minutiA ~/ 60);
    minutiA = minutiA % 60;
    Map<String, int> risultato = {
      "tot_ore_presenza": oreP,
      "tot_min_presenza": minutiP,
      "tot_ore_assenza": oreA,
      "tot_min_assenza": minutiA
    };
    sommaPresenzeAssenze = risultato;
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
  bool isExam;

  Materia(this.sede, this.fine, this.inizio, this.nomeMateria, this.aula,
      this.isExam);
}

class PresenzaAssenza {
  String materia;
  int ore_presenza;
  int minuti_presenza;
  int ore_assenza;
  int minuti_assenza;
  DateTime data;
  DateTime inizio;
  DateTime fine;

  PresenzaAssenza(this.materia, this.ore_presenza, this.minuti_presenza,
      this.ore_assenza, this.minuti_assenza, this.data, this.inizio, this.fine);
}
