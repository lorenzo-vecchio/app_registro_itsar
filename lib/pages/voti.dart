import 'package:flutter/material.dart';
import 'package:prova_registro/data.dart';

class Voti extends StatefulWidget {
  const Voti({Key? key}) : super(key: key);

  @override
  State<Voti> createState() => _VotiState();
}

class _VotiState extends State<Voti> {
  List<Voto> voti = [];
  double? media;
  @override
  void initState() {

    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = Data();
    final jsonData = await data.readData_returnJson();
    setState(() {
      voti = Data.fromJson(jsonData).votiList;
      double somma = 0;
      for (Voto voto in voti) {
        somma += voto.voto;
      }
      media = somma / voti.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: voti.length,
        itemBuilder: (context, index) {
          final voto = voti[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(voto.nomeMateria),
              subtitle: Text(voto.voto.toString()),
            ),
          );
        },
      ),
    );
  }
}