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

  @override
  void initState() {
    super.initState();
    materieOggi = _findTodayMaterie();
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
      body: GestureDetector(
        onTap: () => {debugPrint("pollo")},
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                title: const Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 0, 20),
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 30, 0, 30),
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
                        } else {
                          List<Widget> listaMaterie = [];
                          for (var i = 0; i < materieOggi.length; i++) {
                            listaMaterie.add(
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 30, 0, 30),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: i == 0 ? Colors.red : Colors.indigo,
                                  ),
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: FractionallySizedBox(
                                    widthFactor: 0.80,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  '${materieOggi[i].nomeMateria}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                                text:
                                                    '\n\nAula: ${materieOggi[i].aula}'),
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
                        // } else if (materieOggi.length == 1) {
                        //   return Column(
                        //     children: [
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(15),
                        //       color: Colors.red,
                        //     ),
                        //     padding:
                        //         const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        //     child: FractionallySizedBox(
                        //       widthFactor: 0.80,
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: RichText(
                        //           text: TextSpan(
                        //             style:
                        //                 DefaultTextStyle.of(context).style,
                        //             children: <TextSpan>[
                        //               TextSpan(
                        //                 text:
                        //                     '${materieOggi[0].nomeMateria}',
                        //                 style: TextStyle(
                        //                     fontWeight: FontWeight.bold),
                        //               ),
                        //               TextSpan(
                        //                   text:
                        //                       '\n\nAula: ${materieOggi[0].aula}'),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        //     ],
                        //   );
                        // } else {
                        //   return Column(
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(15),
                        //             color: Colors.red,
                        //           ),
                        //           padding:
                        //               const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        //           child: FractionallySizedBox(
                        //             widthFactor: 0.80,
                        //             child: Padding(
                        //               padding: const EdgeInsets.all(8.0),
                        //               child: RichText(
                        //                 text: TextSpan(
                        //                   style:
                        //                       DefaultTextStyle.of(context).style,
                        //                   children: <TextSpan>[
                        //                     TextSpan(
                        //                       text:
                        //                           '${materieOggi[0].nomeMateria}',
                        //                       style: TextStyle(
                        //                           fontWeight: FontWeight.bold),
                        //                     ),
                        //                     TextSpan(
                        //                         text:
                        //                             '\n\nAula: ${materieOggi[0].aula}'),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       Padding(
                        //         padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(15),
                        //             color: Colors.indigo,
                        //           ),
                        //           padding:
                        //               const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        //           child: FractionallySizedBox(
                        //             widthFactor: 0.80,
                        //             child: Padding(
                        //               padding: const EdgeInsets.all(8.0),
                        //               child: RichText(
                        //                 text: TextSpan(
                        //                   style:
                        //                       DefaultTextStyle.of(context).style,
                        //                   children: <TextSpan>[
                        //                     TextSpan(
                        //                       text:
                        //                           '${materieOggi[1].nomeMateria}',
                        //                       style: TextStyle(
                        //                           fontWeight: FontWeight.bold),
                        //                     ),
                        //                     TextSpan(
                        //                         text:
                        //                             '\n\nAula: ${materieOggi[1].aula}'),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   );
                        // }
                      }()),
                ),
              ),
            ),
            Average()
          ],
        ),
      ),
    );
  }
}
