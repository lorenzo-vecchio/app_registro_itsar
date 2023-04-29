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
  double sommaPresenze = globalData.presenzeList
      .fold(0, (total, presenza) => total + presenza.ore_presenza);
  double sommaAssenze = globalData.presenzeList
      .fold(0, (total, presenza) => total + presenza.ore_assenza);
  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);

    // gets if it's in dark mode or not
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
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
                        color:
                            isDarkMode ? Colors.green : Colors.green.shade500,
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
                        color: isDarkMode ? Colors.red : Colors.red.shade400,
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
                padding: EdgeInsets.symmetric(
                    horizontal: _mediaQueryData.size.width * 0.025),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: isDarkMode
                      ? Colors.grey.shade900.withOpacity(0.50)
                      : Colors.grey.shade400.withOpacity(0.50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color:
                            isDarkMode ? Colors.green : Colors.green.shade500,
                      ),
                      height: 90,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Presenza:\n',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          children: [
                            TextSpan(
                              text: '${sommaPresenze}h',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
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
                        color: isDarkMode ? Colors.red : Colors.red.shade400,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Assenza:\n',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          children: [
                            TextSpan(
                              text: '${sommaAssenze}h',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
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
            return Padding(
              padding: EdgeInsets.fromLTRB(25, 8, 8, 0),
              child: ListTile(
                tileColor: isDarkMode ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: isDarkMode ? Colors.black : Colors.white,
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
