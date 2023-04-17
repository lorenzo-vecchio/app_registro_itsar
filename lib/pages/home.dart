import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import '../globals.dart';
import '../data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  List<Materia> materieOggi = [];

  @override
  void initState() {
    super.initState();
    materieOggi = _findTodayMaterie();
  }

  double _calcolaMedia() {
    int somma = 0;
    for (Voto voto in globalData.votiList) {
      somma += voto.voto;
    }
    return somma / globalData.votiList.length;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 0, 20),
                child: Text(
                  'Today',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.shade900.withOpacity(0.50),
                    ),
                    child: () {
                      if (materieOggi.isEmpty) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.green,
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 15),
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
                      } else if (materieOggi.length == 1) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.red,
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                child: FractionallySizedBox(
                                  widthFactor: 0.80,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '${materieOggi[0].nomeMateria}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text:
                                                  '\n\nAula: ${materieOggi[0].aula}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.red,
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                child: FractionallySizedBox(
                                  widthFactor: 0.80,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '${materieOggi[0].nomeMateria}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text:
                                                  '\n\nAula: ${materieOggi[0].aula}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.indigo,
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                child: FractionallySizedBox(
                                  widthFactor: 0.80,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '${materieOggi[1].nomeMateria}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text:
                                                  '\n\nAula: ${materieOggi[1].aula}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              title: IgnorePointer(
                child: CircularSeekBar(
                  width: double.infinity,
                  height: 250,
                  minProgress: 0,
                  maxProgress: 30,
                  progress: _calcolaMedia(),
                  barWidth: 15,
                  startAngle: 45,
                  sweepAngle: 270,
                  strokeCap: StrokeCap.round,
                  progressGradientColors: const [
                    Colors.red,
                    Colors.orange,
                    Colors.green
                  ],
                  innerThumbRadius: 13,
                  innerThumbStrokeWidth: 3,
                  innerThumbColor: Colors.white,
                  outerThumbRadius: 13,
                  outerThumbStrokeWidth: 10,
                  outerThumbColor: Colors.blueAccent,
                  animation: true,
                  valueNotifier: _valueNotifier,
                  child: Center(
                    child: ValueListenableBuilder(
                        valueListenable: _valueNotifier,
                        builder: (_, double value, __) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${double.parse((value).toStringAsFixed(2))}',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('media',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
