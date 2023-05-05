import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:prova_registro/data.dart';
import 'package:prova_registro/globals.dart';
import 'package:prova_registro/screen_size.dart';
import 'package:flutter_custom_selector/flutter_custom_selector.dart';

import '../widgets/customMultiSelect.dart';

class Presenze extends StatefulWidget {
  const Presenze({super.key});

  @override
  State<Presenze> createState() => _PresenzeState();
}

class _PresenzeState extends State<Presenze> {
  List<String> listaNomiMaterie = [];
  List<PresenzaAssenza> listaMaterie = globalData.presenzeList;

  List<String> _getNomiMaterie() {
    List<String> risultato = [];
    for (PresenzaAssenza materia in globalData.presenzeList) {
      String titolo = materia.materia;
      if (!risultato.contains(titolo)) {
        risultato.add(titolo);
      }
    }
    return risultato;
  }

  void _selezioneMaterie(List<dynamic> value) {
    List<String> selectedItems = value.cast<String>();
    List<PresenzaAssenza> filteredList = [];
    if (selectedItems.length == 0) {
      listaMaterie = globalData.presenzeList;
      setState(() {});
      return;
    }
    for (PresenzaAssenza item in globalData.presenzeList) {
      if (selectedItems.contains(item.materia)) {
        filteredList.add(item);
      }
    }
    listaMaterie = filteredList;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    listaNomiMaterie = _getNomiMaterie();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ScreenSize.init(context);
  }

  @override
  Widget build(BuildContext context) {
    // gets if it's in dark mode or not
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: ListView.builder(
        itemCount: listaMaterie.length + 2,
        itemBuilder: (context, index) {
          if (index >= 2) {
            PresenzaAssenza presenza = listaMaterie[index - 2];
            return Padding(
              padding: EdgeInsets.fromLTRB(ScreenSize.padding10,
                  ScreenSize.padding10, ScreenSize.padding10, 0),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.padding10,
                          vertical: ScreenSize.padding8),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.padding10,
                          vertical: ScreenSize.padding8),
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
              padding: EdgeInsets.fromLTRB(ScreenSize.padding10,
                  ScreenSize.padding10, ScreenSize.padding10, 0),
              child: Container(
                height: 150,
                padding: EdgeInsets.symmetric(horizontal: ScreenSize.padding30),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.padding30),
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
                              text:
                                  '${globalData.sommaPresenzeAssenze['tot_ore_presenza']}h ${globalData.sommaPresenzeAssenze['tot_min_presenza']}m',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.padding30),
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
                              text:
                                  '${globalData.sommaPresenzeAssenze['tot_ore_assenza']}h ${globalData.sommaPresenzeAssenze['tot_min_assenza']}m',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(ScreenSize.screenWidth * 0.05,
                      ScreenSize.padding8, ScreenSize.padding8, 0),
                  child: ListTile(
                    tileColor: isDarkMode ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: isDarkMode ? Colors.black : Colors.white,
                      ),
                    ),
                    title: const Text(
                      "Presenze",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(ScreenSize.padding10,
                      ScreenSize.padding10, ScreenSize.padding10, 0),
                  child: MyCustomMultiSelectField<String>(
                    title: "Filtra per materia",
                    selectedItemColor: Colors.red,
                    titleColor: isDarkMode ? Colors.white : Colors.black,
                    decoration: InputDecoration(
                        fillColor: isDarkMode ? Colors.black : Colors.white,
                        suffixIconColor:
                            isDarkMode ? Colors.white : Colors.black,
                        suffixIcon: Icon(Icons.expand_more)),
                    items: listaNomiMaterie,
                    enableAllOptionSelect: true,
                    onSelectionDone: _selezioneMaterie,
                    itemAsString: (item) => item.toString(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
