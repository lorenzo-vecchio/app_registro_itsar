library globals;

import 'package:flutter/material.dart';
import 'package:prova_registro/data.dart';

Data globalData = Data();
bool alreadyHaveData = false;

// ========================================= COLORI: =========================================

// sfondo pagine
Color backgroundDarkMode = Colors.black;
Color backgroundLightMode = Colors.white;
// barra di navigazione
Color notActiveTextDarkMode = Color.fromARGB(255, 126, 126, 126);
Color notActiveTextLightMode = Color.fromARGB(255, 124, 124, 124);
Color activeTextDarkMode = Colors.white;
Color activeTextLightMode = Colors.black;
Color tabBackgroundColorDarkMode = Colors.grey.shade900.withOpacity(0.50);
Color tabBackgroundColorLightMode = Colors.grey.shade400.withOpacity(0.50);

// ------------------------ HOME ------------------------
//elemento oggi niente
Color backgroundOggiNienteDarkMode = Colors.green;
Color backgroundOggiNienteLightMode = Colors.green.shade500;
// lezione mattina
Color morningLessonDarkMode = Colors.red;
Color morningLessonLightMode = Colors.yellow;
// lezione pomeriggio
Color afternoonLessonDarkMode = Colors.indigo;
Color afternoonLessonLightMode = Colors.lightBlue;
// carousel indicator
Color carouselIndicatorNotActiveDarkMode = Colors.white30;
Color carouselIndicatorNotActiveLightMode =
    Colors.grey.shade300.withOpacity(0.50);
Color carouselIndicatorActiveDarkMode = Colors.white;
Color carouselIndicatorActiveLightMode = Colors.black;
// sfondo componenti Listtile
Color tileBackgroundDarkMode = Colors.grey.shade900.withOpacity(0.50);
Color tileBackgoundLightMode = Colors.grey.shade300.withOpacity(0.50);
// ========================================= FINE-COLORI =========================================
List<int> hoursToDifferent(double val) {
  double num = val;
  String numString = num.toString();

  List<String> parts = numString.split('.');
  String decimalPart = parts.length > 1 ? parts[1] : '';

  int integerPartInt = int.parse(parts[0]);
  int decimalPartInt = int.parse(decimalPart);

  if (decimalPartInt >= 60) {
    integerPartInt += 1;
    decimalPartInt -= 60;
  }
  return [integerPartInt, decimalPartInt];
}

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
