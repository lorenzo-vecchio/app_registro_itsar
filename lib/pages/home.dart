import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../globals.dart';
import '../data.dart';
import '../widgets/average.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Materia> materieOggi = [];
  List<Materia> materieDomani = [];
  List<List<Materia>> materie = [];
  int sommaPresenze = globalData.presenzeList
      .fold(0, (total, presenza) => total + presenza.ore_presenza);
  int sommaAssenze = globalData.presenzeList
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
    return Scaffold(
      backgroundColor: Colors.black,
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
                    print(currentPageIndex);
                  });
                },
              ),
              items: materie.map((i) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(0, 25, 0, 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    title: Padding(
                      padding: EdgeInsets.fromLTRB(25, 0, 0, 20),
                      child: Text(
                        '${materie.indexOf(i) == 0 ? 'Today' : 'Tomorrow'}',
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.grey.shade900.withOpacity(0.50),
                          ),
                          child: () {
                            if (i.isEmpty) {
                              return Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 30, 0, 30),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.green,
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 15),
                                      child: const FractionallySizedBox(
                                        widthFactor: 0.80,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
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
                                        ? EdgeInsets.fromLTRB(0, 30, 0, 0)
                                        : EdgeInsets.fromLTRB(0, 30, 0, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: i[j]
                                                    .inizio
                                                    .toString()
                                                    .substring(11) ==
                                                '09:00:00.000'
                                            ? Colors.red
                                            : Colors.indigo,
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 15),
                                      child: FractionallySizedBox(
                                        widthFactor: 0.80,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                                                        '\n\nAula: ${i[j].aula}'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
              CarouselIndicator(
                count: materie.length,
                index: currentPageIndex,
              ),
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(0, 25, 0, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                title: const Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 0, 20),
                  child: Text(
                    'Presenze',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.symmetric(horizontal: 28),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade900.withOpacity(0.50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.green,
                          ),
                          height: 60,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Presenza: ${sommaPresenze}h',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.red,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Assenza: ${sommaAssenze}h',
                            style: const TextStyle(
                                color: Colors.white,
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
