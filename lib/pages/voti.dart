import 'package:flutter/material.dart';

class Voti extends StatefulWidget {
  const Voti({Key? key}) : super(key: key);

  @override
  State<Voti> createState() => _VotiState();
}

class _VotiState extends State<Voti> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('voti'),
    );
  }
}
