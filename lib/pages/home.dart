import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../globals.dart';
import '../data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Materia> materieOggi = [];
  List<Materia> materieDomani = [];
  List<List<Materia>> materie = [];
  double sommaPresenze = globalData.presenzeList
      .fold(0, (total, presenza) => total + presenza.ore_presenza);
  double sommaAssenze = globalData.presenzeList
      .fold(0, (total, presenza) => total + presenza.ore_assenza);

  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    materieOggi = _findTodayMaterie();
    materieDomani = _findTomorrowMaterie();
    materie.add(materieOggi);
    materie.add(materieDomani);
  }

  List<Materia> _findTodayMaterie() {
    final now = DateTime.now();
    return globalData.materieList
        .where((materia) =>
            materia.inizio.year == now.year &&
            materia.inizio.month == now.month &&
            materia.inizio.day == now.day)
        .toList();
  }

  List<Materia> _findTomorrowMaterie() {
    final now = DateTime.now();
    return globalData.materieList
        .where((materia) =>
            materia.inizio.year == now.year &&
            materia.inizio.month == now.month &&
            materia.inizio.day == now.day + 1)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // gets if it's in dark mode or not
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: isDarkMode ? backgroundDarkMode : backgroundLightMode,
      body: GestureDetector(
        onTap: () => {debugPrint("pollo")},
        child: ListView(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 500,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
              ),
              items: materie.map((i) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                      _mediaQueryData.size.width * 0.03,
                      _mediaQueryData.size.width * 0.03,
                      _mediaQueryData.size.width * 0.03,
                      _mediaQueryData.size.width * 0.04),
                  child: ListTile(
                    contentPadding: EdgeInsets.fromLTRB(
                      0,
                      _mediaQueryData.size.width * 0.03,
                      0,
                      _mediaQueryData.size.width * 0.15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    title: Padding(
                      padding: EdgeInsets.fromLTRB(
                          _mediaQueryData.size.width * 0.055,
                          0,
                          0,
                          _mediaQueryData.size.width * 0.04),
                      child: Text(
                        '${materie.indexOf(i) == 0 ? 'Today' : 'Tomorrow'}',
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.fromLTRB(
                          _mediaQueryData.size.width * 0.05,
                          0,
                          _mediaQueryData.size.width * 0.05,
                          _mediaQueryData.size.width * 0.1), //20,0,20,40
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: isDarkMode
                                ? Colors.grey.shade900.withOpacity(0.50)
                                : Colors.grey.shade300.withOpacity(0.50),
                          ),
                          child: () {
                            if (i.isEmpty) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0,
                                        _mediaQueryData.size.width * 0.06,
                                        0,
                                        _mediaQueryData.size.width *
                                            0.06), //0,30,0,30
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: isDarkMode
                                            ? backgroundOggiNienteDarkMode
                                            : backgroundOggiNienteLightMode,
                                      ),
                                      padding: EdgeInsets.fromLTRB(
                                          0,
                                          _mediaQueryData.size.width * 0.04,
                                          0,
                                          _mediaQueryData.size.width *
                                              0.04), //0,15,0,15
                                      child: FractionallySizedBox(
                                        widthFactor: 0.80,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              _mediaQueryData.size.width *
                                                  0.02),
                                          child: const Text(
                                            'Oggi niente!!!',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              List<Widget> listaMaterie = [];
                              for (var j = 0; j < i.length; j++) {
                                listaMaterie.add(
                                  Padding(
                                    padding: j == 0
                                        ? EdgeInsets.fromLTRB(
                                            0,
                                            _mediaQueryData.size.width * 0.07,
                                            0,
                                            0) //0,30,0,0
                                        : EdgeInsets.fromLTRB(
                                            0,
                                            _mediaQueryData.size.width * 0.07,
                                            0,
                                            0), //0,30,0,0
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: i[j]
                                                    .inizio
                                                    .toString()
                                                    .substring(11) ==
                                                '09:00:00.000'
                                            ? isDarkMode
                                                ? morningLessonDarkMode
                                                : morningLessonLightMode
                                            : isDarkMode
                                                ? afternoonLessonDarkMode
                                                : afternoonLessonLightMode,
                                      ),
                                      padding: EdgeInsets.fromLTRB(
                                          0,
                                          _mediaQueryData.size.width * 0.04,
                                          0,
                                          _mediaQueryData.size.width *
                                              0.04), //0,15,0,15
                                      child: FractionallySizedBox(
                                        widthFactor: 0.80,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              _mediaQueryData.size.width *
                                                  0.02), //8
                                          child: RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: '${i[j].nomeMateria}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                    text:
                                                        '\nAula: ${i[j].aula}\nOrario: ${i[j].inizio.toString().substring(11).substring(0, 5)}-${i[j].fine.toString().substring(11).substring(0, 5)}\nIntervallo: ${getInterval(i[j])}'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Column(
                                children: listaMaterie,
                              );
                            }
                          }()),
                    ),
                  ),
                );
              }).toList(),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CarouselIndicator(
                count: materie.length,
                index: currentPageIndex,
                color: isDarkMode
                    ? carouselIndicatorNotActiveDarkMode
                    : carouselIndicatorNotActiveLightMode,
                activeColor: isDarkMode
                    ? carouselIndicatorActiveDarkMode
                    : carouselIndicatorActiveLightMode,
              ),
            ]),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  _mediaQueryData.size.width * 0.05,
                  _mediaQueryData.size.width *
                      0.12, //modificare distanza dal Carosel indicator
                  _mediaQueryData.size.width * 0.05,
                  _mediaQueryData.size.width * 0.025), //20,50,20,10
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(
                    0,
                    _mediaQueryData.size.width * 0.055,
                    0,
                    _mediaQueryData.size.width * 0.025), //0,25,0,10
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                title: Padding(
                  padding: EdgeInsets.fromLTRB(
                      _mediaQueryData.size.width * 0.055,
                      0,
                      0,
                      _mediaQueryData.size.width * 0.055), //25,0,0,25
                  child: const Text(
                    'Presenze',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(
                      _mediaQueryData.size.width * 0.025,
                      0,
                      _mediaQueryData.size.width * 0.025,
                      _mediaQueryData.size.width * 0.025), //20,0,20,20
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.symmetric(
                        horizontal: _mediaQueryData.size.width * 0.058), //28
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: isDarkMode
                          ? Colors.grey.shade900.withOpacity(0.50)
                          : Colors.grey.shade300.withOpacity(0.50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: isDarkMode
                                ? Colors.green
                                : Colors.green.shade400,
                          ),
                          height: 60,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(
                              _mediaQueryData.size.width * 0.025),
                          child: Text(
                            'Presenza: ${sommaPresenze}h',
                            style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color:
                                isDarkMode ? Colors.red : Colors.red.shade300,
                          ),
                          padding: EdgeInsets.all(
                              _mediaQueryData.size.width * 0.025),
                          child: Text(
                            'Assenza: ${sommaAssenze}h',
                            style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
