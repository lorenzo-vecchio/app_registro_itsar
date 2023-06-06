import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../globals.dart';
import '../providers/themeProvider.dart';
import '../screen_size.dart';

class LessonOnTap extends StatefulWidget {
  final i;
  final List<Widget> listaMaterie;
  final j;

  const LessonOnTap(
      {Key? key, required this.i, required this.listaMaterie, required this.j})
      : super(key: key);

  @override
  State<LessonOnTap> createState() => _LessonOnTapState(i, listaMaterie, j);
}

class _LessonOnTapState extends State<LessonOnTap> {
  final i;
  final j;
  final List<Widget> listaMaterie;
  bool isPressed = false;

  _LessonOnTapState(this.i, this.listaMaterie, this.j);
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(builder: (context, model, child) {
      List<Widget> listaMaterie = [];
      return Padding(
        padding: j == 0
            ? EdgeInsets.fromLTRB(0, ScreenSize.screenHeight * 0.04, 0, 0)
            : EdgeInsets.fromLTRB(0, ScreenSize.screenHeight * 0.04, 0, 0),
        child: GestureDetector(
          onTapDown: (_) {
            setState(() {
              isPressed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              isPressed = false;
            });
          },
          onTapCancel: () {
            setState(() {
              isPressed = false;
            });
          },
          onTap: () {
            // print(isPressed);
            showDialog(
              context: context,
              builder: (context) => Theme(
                data: ThemeData(
                  dialogTheme: DialogTheme(
                    backgroundColor:
                        i[j].inizio.toString().substring(11) == '09:00:00.000'
                            ? model.isDarkMode
                                ? morningLessonDarkMode
                                : morningLessonLightMode
                            : model.isDarkMode
                                ? afternoonLessonDarkMode
                                : afternoonLessonLightMode,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                child: AlertDialog(
                  title: Text(
                    i[j].nomeMateria,
                    style: TextStyle(
                      color: model.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  content: Text(
                    'Aula: ${i[j].aula}\n'
                    'Orario: ${i[j].inizio.toString().substring(11).substring(0, 5)}-${i[j].fine.toString().substring(11).substring(0, 5)}\n'
                    'Intervallo: ${getInterval(i[j])}',
                    style: TextStyle(
                      color: model.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  actions: [
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          alignment: Alignment.center,
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )
                          ),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.grey.shade300;
                              }
                              return i[j].inizio.toString().substring(11) ==
                                      '09:00:00.000'
                                  ? model.isDarkMode
                                      ? afternoonLessonDarkMode
                                      : afternoonLessonLightMode
                                  : model.isDarkMode
                                      ? morningLessonDarkMode
                                      : morningLessonLightMode;
                            },
                          ),
                        ),
                        child: Text(
                          'Chiudi',
                          style: TextStyle(
                            color: model.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: isPressed
                    ? i[j].inizio.toString().substring(11) == '09:00:00.000'
                        ? model.isDarkMode
                            ? morningLessonDarkMode.withOpacity(0.8)
                            : morningLessonLightMode.withOpacity(0.8)
                        : model.isDarkMode
                            ? afternoonLessonDarkMode.withOpacity(0.8)
                            : afternoonLessonLightMode.withOpacity(0.8)
                    : i[j].inizio.toString().substring(11) == '09:00:00.000'
                        ? model.isDarkMode
                            ? morningLessonDarkMode
                            : morningLessonLightMode
                        : model.isDarkMode
                            ? afternoonLessonDarkMode
                            : afternoonLessonLightMode),
            padding: EdgeInsets.symmetric(
              vertical: ScreenSize.screenHeight * 0.008,
              horizontal: ScreenSize.padding8,
            ),
            child: FractionallySizedBox(
              widthFactor: 0.80,
              child: Padding(
                padding: EdgeInsets.all(ScreenSize.padding8),
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: i[j].nomeMateria,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: model.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            '\nAula: ${i[j].aula}\nOrario: ${i[j].inizio.toString().substring(11).substring(0, 5)}-${i[j].fine.toString().substring(11).substring(0, 5)}\nIntervallo: ${getInterval(i[j])}',
                        style: TextStyle(
                          color: model.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
