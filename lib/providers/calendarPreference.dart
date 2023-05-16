library calendarPreference;

import 'package:shared_preferences/shared_preferences.dart';

bool calendarioMensile = true;

void loadBoolMensile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  calendarioMensile = prefs.getBool('mensile') ?? true;
}

void changeMensilePreference(bool mens) async {
  calendarioMensile = mens;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('mensile', mens);
}
