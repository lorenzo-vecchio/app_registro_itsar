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


  void _createNeatCleanEventList () {
    List<Materia> eventiMaterie = globalData.materieList;
    for(Materia materia in eventiMaterie) {
      NeatCleanCalendarEvent evento = NeatCleanCalendarEvent('${materia.nomeMateria}',
        startTime: materia.inizio,
        endTime: materia.fine,
        color: Colors.indigo,
      );
      _eventList.add(evento);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Calendar(
          eventTileHeight: 100,
          startOnMonday: true,
          weekDays: ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
          eventsList: _eventList,
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: Colors.pink,
          selectedTodayColor: Colors.red,
          todayColor: Colors.blue,
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
        ),
      ),
    );
  }
}
