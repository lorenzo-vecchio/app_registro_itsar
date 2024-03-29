import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../globals.dart';

class Average extends StatelessWidget {
  Average({super.key});

  double _calcolaMedia() {
    int somma = 0;
    int votoDaEliminare = 0;
    int totVoti = 0;
    for (Voto voto in globalData.votiList) {
      voto.nomeMateria.contains("UFT05")
          ? votoDaEliminare++
          : somma = somma + voto.voto;
    }
    totVoti = globalData.votiList.length - votoDaEliminare;
    return somma / totVoti;
  }

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          mediaQueryData.size.width * 0.048,
          mediaQueryData.size.width * 0.048,
          mediaQueryData.size.width * 0.048,
          mediaQueryData.size.width * 0.048),
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
    );
  }
}
