import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:prova_registro/data.dart';
import 'package:prova_registro/globals.dart';

class Presenze extends StatefulWidget {
  const Presenze({super.key});

  @override
  State<Presenze> createState() => _PresenzeState();
}

class _PresenzeState extends State<Presenze> {
  int sommaPresenze = globalData.presenzeList
      .fold(0, (total, presenza) => total + presenza.ore_presenza);
  int sommaAssenze = globalData.presenzeList
      .fold(0, (total, presenza) => total + presenza.ore_assenza);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: globalData.presenzeList.length + 2,
        itemBuilder: (context, index) {
          if (index >= 2) {
            PresenzaAssenza presenza = globalData.presenzeList[index - 2];
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ListTile(
                title: Text(
                  presenza.materia,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                    '${DateFormat('dd/MM/yyyy').format(presenza.data)}  -  ${DateFormat('HH:mm').format(presenza.inizio)} | ${DateFormat('HH:mm').format(presenza.fine)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '${presenza.ore_presenza}h',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '${presenza.ore_assenza}h',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Container(
                height: 150,
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
                      height: 90,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Presenza:\n',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          children: [
                            TextSpan(
                              text: '${sommaPresenze}h',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Assenza:\n',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          children: [
                            TextSpan(
                              text: '${sommaAssenze}h',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                title: Text(
                  "Presenze",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              ),
            );
          }
        },
      ),
    );
  }
}
