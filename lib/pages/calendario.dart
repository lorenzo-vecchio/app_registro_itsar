import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:prova_registro/data.dart';
import 'package:prova_registro/globals.dart';
import 'package:provider/provider.dart';
import '../providers/themeProvider.dart';
import '../providers/calendarPreference.dart';

class Calendario extends StatefulWidget {
  const Calendario({Key? key}) : super(key: key);

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  final List<NeatCleanCalendarEvent> _eventList = [];
  final List<NeatCleanCalendarEvent> _examList = [];
  bool soloEsami = false;
  IconData filterIcon = Icons.filter_list;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final themeProvider = Provider.of<ThemeModel>(context, listen: false);
    _createNeatCleanEventList(themeProvider.isDarkMode);
    _createExamList(themeProvider.isDarkMode);
  }

  void _createNeatCleanEventList(isDarkMode) {
    String searchText = '- Aula:';
    List<Materia> eventiMaterie = globalData.materieList;
    for (Materia materia in eventiMaterie) {
      int index = materia.nomeMateria.indexOf(searchText);
      if (index != -1) {
        materia.nomeMateria = materia.nomeMateria.substring(0, index).trim();
      }
      String intervallo = 'Intervallo: ${getInterval(materia)}';
      NeatCleanCalendarEvent evento = NeatCleanCalendarEvent(
        '${materia.nomeMateria}\n\n${materia.aula}',
        startTime: materia.inizio,
        endTime: materia.fine,
        description: intervallo,
        color: () {
          bool hasFourHours = materia.fine.difference(materia.inizio) ==
              const Duration(hours: 4);
          if (materia.isExam) {
            return isDarkMode ? Colors.white : Colors.black;
          }
          if (hasFourHours && materia.inizio.hour < 11) {
            return isDarkMode ? morningLessonDarkMode : morningLessonLightMode;
          }
          if (hasFourHours && !(materia.inizio.hour < 11)) {
            return isDarkMode
                ? afternoonLessonDarkMode
                : afternoonLessonLightMode;
          }
          if (materia.fine.difference(materia.inizio) ==
              const Duration(hours: 9)) {
            return isDarkMode
                ? backgroundOggiNienteDarkMode
                : backgroundOggiNienteLightMode;
          } else {
            return isDarkMode ? extraLessonDarkMode : extraLessonLightMode;
          }
        }(),
      );
      _eventList.add(evento);
    }
  }

  void _createExamList(isDarkMode) {
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
            bool hasFourHours = materia.fine.difference(materia.inizio) ==
                const Duration(hours: 4);
            if (materia.isExam) {
              return isDarkMode ? Colors.white : Colors.black;
            }
            if (hasFourHours && materia.inizio.hour < 11) {
              return isDarkMode
                  ? morningLessonDarkMode
                  : morningLessonLightMode;
            }
            if (hasFourHours && !(materia.inizio.hour < 11)) {
              return isDarkMode
                  ? afternoonLessonDarkMode
                  : afternoonLessonLightMode;
            }
            if (materia.fine.difference(materia.inizio) ==
                const Duration(hours: 9)) {
              return isDarkMode
                  ? backgroundOggiNienteDarkMode
                  : backgroundOggiNienteLightMode;
            } else {
              return isDarkMode ? extraLessonDarkMode : extraLessonLightMode;
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
      filterIcon = soloEsami
          ? Icons.filter_list_off
          : Icons.filter_list; // update the icon
    });
  }

  @override
  Widget build(BuildContext context) {
    // gets if it's in dark mode or not
    return Consumer<ThemeModel>(builder: (context, model, child) {
      return Scaffold(
        floatingActionButton: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: FloatingActionButton(
            key: ValueKey(filterIcon),
            onPressed: _filtroSoloEsami,
            backgroundColor: Colors.red,
            child: Icon(filterIcon),
          ),
        ),
        body: SafeArea(
          child: Calendar(
            eventTileHeight: 140,
            startOnMonday: true,
            weekDays: const ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'],
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
            isExpanded: calendarioMensile,
            expandableDateFormat: 'EEEE dd MMMM yyyy',
            datePickerType: DatePickerType.date,
            dayOfWeekStyle: TextStyle(
                color: model.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 11),
            displayMonthTextStyle: TextStyle(
              color: model.isDarkMode ? Colors.white : Colors.black,
            ),
            defaultDayColor: model.isDarkMode ? Colors.white : Colors.black,
            defaultOutOfMonthDayColor: Colors.grey.shade500,
            bottomBarTextStyle: TextStyle(
              color: model.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    });
  }
}
