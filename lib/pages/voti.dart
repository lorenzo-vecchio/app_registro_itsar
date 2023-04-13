import 'package:flutter/material.dart';
import '../globals.dart';

class Voti extends StatefulWidget {
  const Voti({Key? key}) : super(key: key);

  @override
  State<Voti> createState() => _VotiState();
}

class _VotiState extends State<Voti> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: globalData.votiList.length,
        itemBuilder: (context, index) {
          final voto = globalData.votiList[index];
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