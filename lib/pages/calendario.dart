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

  String _getInterval(String room) {
    switch (room) {
      case "CRESPI-1":
        return '10:15 - 15:15';
      case "CRESPI-3":
        return '11:15 - 16:15';
      case "CRESPI-4":
        return '11:30 - 16:30';
      case "CRESPI-5":
        return '10:45 - 15:45';
      case "CRESPI-6":
        return '10:30 - 15:30';
      case "CRESPI-7":
        return '11:00 - 16:00';
      case "CRESPI-P1":
        return '11:00 - 16:00';
      case "CRESPI-P2":
        return '11:15 - 16:15';
      default:
    }
    return "N/A";
  }

  void _createNeatCleanEventList() {
    List<Materia> eventiMaterie = globalData.materieList;
    for (Materia materia in eventiMaterie) {
      String intervallo = 'Intervallo: ${_getInterval(materia.aula)}';
      debugPrint(_getInterval(materia.aula));
      NeatCleanCalendarEvent evento = NeatCleanCalendarEvent(
        '${materia.nomeMateria}\n\n${materia.aula}',
        startTime: materia.inizio,
        endTime: materia.fine,
        description: intervallo,
        color: materia.inizio.toString().substring(11) == '09:00:00.000'
            ? Colors.red
            : Colors.indigo,
      );
      _eventList.add(evento);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Calendar(
          eventTileHeight: 130,
          startOnMonday: true,
          weekDays: ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
          eventsList: _eventList,
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: Colors.pink,
          selectedTodayColor: Colors.red,
          todayColor: Colors.red,
          eventColor: null,
          locale: 'en_US',
          todayButtonText: 'Today',
          allDayEventText: 'All Day',
          multiDayEndText: 'End',
          isExpanded: true,
          expandableDateFormat: 'EEEE, dd. MMMM yyyy',
          datePickerType: DatePickerType.date,
          dayOfWeekStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11),
          displayMonthTextStyle: const TextStyle(
            color: Colors.white,
          ),
          defaultDayColor: Colors.white,
          defaultOutOfMonthDayColor: Colors.grey.shade500,
        ),
      ),
    );
  }
}
