import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:prova_registro/data.dart';
import 'package:prova_registro/globals.dart';

class Calendario extends StatefulWidget {
  const Calendario({Key? key}) : super(key: key);

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  final List<NeatCleanCalendarEvent> _eventList = [];

  @override
  void initState() {
    super.initState();
    _createNeatCleanEventList();
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

  void _createNeatCleanEventList() {
    List<Materia> eventiMaterie = globalData.materieList;
    for (Materia materia in eventiMaterie) {
      String intervallo = 'Intervallo: ${getInterval(materia)}';
      NeatCleanCalendarEvent evento = NeatCleanCalendarEvent(
        '${materia.nomeMateria}\n\n${materia.aula}',
        startTime: materia.inizio,
        endTime: materia.fine,
        description: intervallo,
        color: () {
          bool hasFourHours =
              materia.fine.difference(materia.inizio) == Duration(hours: 4);
          if (hasFourHours && materia.inizio.hour < 11) {
            return Colors.red;
          }
          if (hasFourHours && !(materia.inizio.hour < 11)) {
            return Colors.indigo;
          }
          if (materia.fine.difference(materia.inizio) ==
              const Duration(hours: 9)) {
            return Colors.green;
          } else {
            return Colors.yellow;
          }
        }(),
      );
      _eventList.add(evento);
    }
  }

  @override
  Widget build(BuildContext context) {
    // gets if it's in dark mode or not
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Calendar(
          eventTileHeight: 130,
          startOnMonday: true,
          weekDays: ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'],
          eventsList: _eventList,
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: Colors.pink,
          selectedTodayColor: Colors.red,
          todayColor: Colors.red,
          eventColor: null,
          locale: 'it_IT',
          todayButtonText: 'Giorno',
          allDayEventText: 'All Day',
          multiDayEndText: 'End',
          isExpanded: true,
          expandableDateFormat: 'EEEE dd MMMM yyyy',
          datePickerType: DatePickerType.date,
          dayOfWeekStyle: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 11),
          displayMonthTextStyle: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          defaultDayColor: isDarkMode ? Colors.white : Colors.black,
          defaultOutOfMonthDayColor: Colors.grey.shade500,
        ),
      ),
    );
  }
}
