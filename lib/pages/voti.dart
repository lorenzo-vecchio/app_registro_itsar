import 'package:flutter/material.dart';
import '../globals.dart';
import '../data.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';

class Voti extends StatefulWidget {
  const Voti({Key? key}) : super(key: key);

  @override
  State<Voti> createState() => _VotiState();
}

class _VotiState extends State<Voti> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);


  double _calcolaMedia () {
    int somma = 0;
    for (Voto voto in globalData.votiList) {
      somma += voto.voto;
    }
    return somma / globalData.votiList.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: globalData.votiList.length + 2,
        itemBuilder: (context, index) {
          Color getCircleColor (Voto voto) {
            if (voto.voto >= 27.0) {
              return Colors.green;
            } else if (voto.voto > 18.0 && voto.voto < 27) {
              return Colors.orange;
            } else {
              return Colors.red;
            }
          }
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                title: CircularSeekBar(
                  width: double.infinity,
                  height: 250,
                  minProgress: 0,
                  maxProgress: 30,
                  progress: _calcolaMedia(),
                  barWidth: 15,
                  startAngle: 45,
                  sweepAngle: 270,
                  strokeCap: StrokeCap.round,
                  progressGradientColors: const [Colors.red, Colors.orange, Colors.green],
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
                            Text('${double.parse((value).toStringAsFixed(2))}', style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),),
                            Text('media', style: TextStyle(
                                color: Colors.grey.shade500,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                          ],
                        )),
                  ),
                ),
              ),
            );
          }
          if (index == 1) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(25, 8, 8, 0),
              child: ListTile(
                tileColor: Colors.black,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                  ),
                ),
                title: Text("Grades", style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 0, vertical: 0),
              ),
            );
          }
          else {
            final voto = globalData.votiList[index-2];
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0, vertical: 5),
              child: ListTile(
                title: Text(voto.nomeMateria, style: TextStyle(fontWeight: FontWeight.bold),),
                trailing: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getCircleColor(voto),
                  ),
                  child: Text(voto.voto.toString(),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
              ),
            );
          }
        },
      ),
    );
  }
}