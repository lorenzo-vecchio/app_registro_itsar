library globals;

import 'package:prova_registro/data.dart';

Data globalData = Data();
bool alreadyHaveData = false;



 String getInterval(Materia materia) {
    var room = materia.aula;
    bool hasFourHours =
        materia.fine.difference(materia.inizio) == Duration(hours: 4);
    switch (room) {
      case "CRESPI-1":
        if (materia.inizio.hour < 11) {
          return '10:15';
        }
        if (!(materia.inizio.hour < 11)) {
          return '15:15';
        } else {
          return 'Non Definito';
        }
      case "CRESPI-3":
        if (materia.inizio.hour < 11) {
          return '11:15';
        }
        if (!(materia.inizio.hour < 11)) {
          return '16:15';
        } else {
          return 'Non Definito';
        }
      case "CRESPI-4":
        if (materia.inizio.hour < 11) {
          return '11:30';
        }
        if (!(materia.inizio.hour < 11)) {
          return '16:30';
        } else {
          return 'Non Definito';
        }
      case "CRESPI-5":
        if (materia.inizio.hour < 11) {
          return '10:45';
        }
        if (!(materia.inizio.hour < 11)) {
          return '15:45';
        } else {
          return 'Non Definito';
        }
      case "CRESPI-6":
        if (materia.inizio.hour < 11) {
          return '10:30';
        }
        if (!(materia.inizio.hour < 11)) {
          return '15:30';
        } else {
          return 'Non Definito';
        }
      case "CRESPI-7":
        if (materia.inizio.hour < 11) {
          return '11:00';
        }
        if (!(materia.inizio.hour < 11)) {
          return '16:00';
        } else {
          return 'Non Definito';
        }
      case "CRESPI-P1":
        if (materia.inizio.hour < 11) {
          return '11:00';
        }
        if (!(materia.inizio.hour < 11)) {
          return '16:00';
        } else {
          return 'Non Definito';
        }
      case "CRESPI-P2":
        if (materia.inizio.hour < 11) {
          return '11:15';
        }
        if (!(materia.inizio.hour < 11)) {
          return '16:15';
        } else {
          return 'Non Definito';
        }
      default:
        return 'Non Definito';
    }
  }