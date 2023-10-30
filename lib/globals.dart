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
Color notActiveTextDarkMode = const Color.fromARGB(255, 126, 126, 126);
Color notActiveTextLightMode = const Color.fromARGB(255, 124, 124, 124);
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
// Lezioni Extra
Color extraLessonDarkMode = Colors.pink.shade400;
Color extraLessonLightMode = Colors.pinkAccent.shade100;
// carousel indicator
Color carouselIndicatorNotActiveDarkMode = Colors.white30;
Color carouselIndicatorNotActiveLightMode =
    Colors.grey.shade300.withOpacity(0.50);
Color carouselIndicatorActiveDarkMode = Colors.white;
Color carouselIndicatorActiveLightMode = Colors.black;
// sfondo componenti Listtile
Color tileBackgroundDarkMode = Colors.grey.shade900.withOpacity(0.50);
Color tileBackgoundLightMode = Colors.grey.shade300.withOpacity(0.50);
// Colore Rosso ITS
Color darkRedITS = const Color(0xFFc00d0e);
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
  // var room = materia.aula;
  // bool hasFourHours =
  //     materia.fine.difference(materia.inizio) == const Duration(hours: 4);

  if (materia.inizio.hour < 11) {
    return '10:00';
  }
  if (!(materia.inizio.hour < 11)) {
    return '16:00';
  }
  return 'Non definito';
}
