import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class Data {
  List<Voto> votiList = [];
  List<Materia> materieList = [];

  Data() {}

  Data.fromJson(String jsonData) {
    final Map<String, dynamic> jsonMap = json.decode(jsonData);

    // Check if the JSON data is in the old format
    if (jsonMap.containsKey('voti') && jsonMap.containsKey('calendario')) {
      // Data is in the old format
      jsonMap['voti'].forEach((key, value) {
        votiList.add(Voto(key, value));
      });
      jsonMap['calendario'].forEach((element) {
        String nomeMateria = element['title'];
        DateTime inizio = DateTime.parse(element['start']);
        DateTime fine = DateTime.parse(element['end']);
        int sede = int.parse(element['AltraSede']);
        Materia materia = Materia(sede, fine, inizio, nomeMateria);
        materieList.add(materia);
      });
    } else {
      // Data is in the new format
      if (jsonMap.containsKey('votiList')) {
        votiList = List<Voto>.from(
          jsonMap['votiList'].map((x) => Voto.fromJson(x)),
        );
      }
      if (jsonMap.containsKey('materieList')) {
        materieList = List<Materia>.from(
          jsonMap['materieList'].map((x) => Materia.fromJson(x)),
        );
      }
    }
  }

  void saveData() async {
    final path = await getApplicationDocumentsDirectory();
    final file = File('${path.path}/data.json');

    // Convert the lists to JSON
    final jsonData = {
      'votiList': votiList.map((voto) => voto.toJson()).toList(),
      'materieList': materieList.map((materia) => materia.toJson()).toList(),
    };
    final jsonString = jsonEncode(jsonData);

    // Write the JSON string to disk
    await file.writeAsString(jsonString);
  }

  Future<String> readData_returnJson() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');
    final jsonString = await file.readAsString();
    return jsonString;
  }
}

class Voto {
  String nomeMateria;
  int voto;

  Voto(this.nomeMateria, this.voto);

  Voto.fromJson(Map<String, dynamic> json)
      : nomeMateria = json['nomeMateria'],
        voto = json['voto'];

  Map<String, dynamic> toJson() => {'nomeMateria': nomeMateria, 'voto': voto};
}

class Materia {
  int sede;
  DateTime fine;
  DateTime inizio;
  String nomeMateria;

  Materia(this.sede, this.fine, this.inizio, this.nomeMateria);

  Materia.fromJson(Map<String, dynamic> json)
      : sede = json['sede'],
        fine = DateTime.parse(json['fine']),
        inizio = DateTime.parse(json['inizio']),
        nomeMateria = json['nomeMateria'];

  Map<String, dynamic> toJson() => {
    'sede': sede,
    'fine': fine.toIso8601String(),
    'inizio': inizio.toIso8601String(),
    'nomeMateria': nomeMateria,
  };
}