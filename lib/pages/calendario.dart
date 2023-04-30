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
  final List<NeatCleanCalendarEvent> _examList = [];
  bool soloEsami = false;

  @override
  void initState() {
    super.initState();
    _createNeatCleanEventList();
    _createExamList();
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

  void _createExamList() {
    List<Materia> eventiMaterie = globalData.materieList;
    for (Materia materia in eventiMaterie) {
      if (materia.isExam) {
        String intervallo = 'Intervallo: ${getInterval(materia)}';
        NeatCleanCalendarEvent evento = NeatCleanCalendarEvent(
          '${materia.nomeMateria}\n\n${materia.aula}',
          startTime: materia.inizio,
          endTime: materia.fine,
          description: intervallo,
          color: () {
            bool hasFourHours =
                materia.fine.difference(materia.inizio) == Duration(hours: 4);
            if (materia.isExam) {
              return Colors.deepPurple;
            }
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
        _examList.add(evento);
      }
    }
  }

  void _filtroSoloEsami() {
    setState(() {
      soloEsami = !soloEsami; // toggle the boolean value
    });
  }

  @override
  Widget build(BuildContext context) {
    // gets if it's in dark mode or not
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? backgroundDarkMode : backgroundLightMode,
      floatingActionButton: FloatingActionButton(
        onPressed: _filtroSoloEsami,
        child: Icon(Icons.filter_list),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Calendar(
          eventTileHeight: 130,
          startOnMonday: true,
          weekDays: ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'],
          eventsList: soloEsami ? _examList : _eventList,
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: Colors.pink,
          selectedTodayColor: Colors.red,
          todayColor: Colors.red,
          eventColor: null,
          locale: 'it_IT',
          todayButtonText: 'Oggi',
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
