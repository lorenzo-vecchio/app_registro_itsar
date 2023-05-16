import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:prova_registro/data.dart';
import 'package:prova_registro/globals.dart';
import 'package:prova_registro/screen_size.dart';
import 'package:provider/provider.dart';
import '../widgets/filter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/themeProvider.dart';

class Presenze extends StatefulWidget {
  const Presenze({super.key});

  @override
  State<Presenze> createState() => _PresenzeState();
}

class _PresenzeState extends State<Presenze> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ScreenSize.init(context);
  }

  @override
  Widget build(BuildContext context) {
    // gets if it's in dark mode or not
    return Consumer<ThemeModel>(builder: (context, model, child) {
      return Scaffold(
        body: ListView.builder(
          itemCount: globalData.presenzeList.length + 2,
          itemBuilder: (context, index) {
            if (index >= 2) {
              PresenzaAssenza presenza = globalData.presenzeList[index - 2];
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
                              model.isDarkMode ? Colors.green : Colors.green.shade500,
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
                          color: model.isDarkMode ? Colors.red : Colors.red.shade400,
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
                  padding:
                      EdgeInsets.symmetric(horizontal: ScreenSize.padding30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: model.isDarkMode
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
                              model.isDarkMode ? Colors.green : Colors.green.shade500,
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
                              color: model.isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${globalData.sommaPresenzeAssenze['tot_ore_presenza']}h ${globalData.sommaPresenzeAssenze['tot_min_presenza']}m',
                                style: TextStyle(
                                  color:
                                      model.isDarkMode ? Colors.white : Colors.black,
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
                          color: model.isDarkMode ? Colors.red : Colors.red.shade400,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenSize.padding30),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Assenza:\n',
                            style: TextStyle(
                              color: model.isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${globalData.sommaPresenzeAssenze['tot_ore_assenza']}h ${globalData.sommaPresenzeAssenze['tot_min_assenza']}m',
                                style: TextStyle(
                                  color:
                                      model.isDarkMode ? Colors.white : Colors.black,
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
                MaterialButton(
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Theme(
                          data: Theme.of(context),
                          child: FilterDialog(
                            items: listaNomiMaterie,
                            onApply: _selezioneMaterie,
                            selectedItems: selectedFilters,
                            backgroundColor:
                                isDarkMode ? Colors.black : Colors.white,
                            activeColor: Colors.red,
                            notActiveColor:
                                isDarkMode ? Colors.white : Colors.black,
                            tileBackgroundColor: isDarkMode
                                ? Colors.grey.shade900.withOpacity(0.50)
                                : Colors.grey.shade300.withOpacity(0.50),
                            buttonColor: Colors.red,
                          ),
                        );
                      },
                    )
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Filtra per materia'),
                      Icon(Icons.expand_more)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(ScreenSize.padding10),
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: selectedFilters.length == listaNomiMaterie.length
                        ? []
                        : selectedFilters
                            .map((String item) => Container(
                                decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.grey.shade900.withOpacity(0.50)
                                        : Colors.grey.shade300
                                            .withOpacity(0.50),
                                    borderRadius: BorderRadius.circular(200)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 8),
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 13),
                                  ),
                                )))
                            .toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(ScreenSize.padding10),
                      child: Text('Percentuale presenza sul totale:'),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, ScreenSize.padding20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearPercentIndicator(
                        animation: true,
                        barRadius: const Radius.circular(200),
                        width: ScreenSize.screenWidth * 0.8,
                        lineHeight: 23.0,
                        percent: _getPercentPresenze(listaMaterie) / 100,
                        backgroundColor: isDarkMode
                            ? Colors.grey.shade900.withOpacity(0.50)
                            : Colors.grey.shade300.withOpacity(0.50),
                        progressColor: Colors.red,
                        center: Text(
                          '${_getPercentPresenze(listaMaterie).toStringAsFixed(2)}%',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
