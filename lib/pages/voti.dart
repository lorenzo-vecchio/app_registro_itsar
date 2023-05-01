import 'package:flutter/material.dart';
import '../globals.dart';
import '../data.dart';
import '../screen_size.dart';
import '../widgets/average.dart';

class Voti extends StatefulWidget {
  const Voti({Key? key}) : super(key: key);

  @override
  State<Voti> createState() => _VotiState();
}

class _VotiState extends State<Voti> {

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
        itemCount: globalData.votiList.length + 2,
        itemBuilder: (context, index) {
          Color getCircleColor(Voto voto) {
            if (voto.voto >= 27.0) {
              return Colors.green;
            } else if (voto.voto > 18.0 && voto.voto < 27) {
              return Colors.orange;
            } else {
              return Colors.red;
            }
          }

          if (index == 0) {
            return Average();
          }
          if (index == 1) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                ScreenSize.screenWidth * 0.065,
                ScreenSize.screenHeight * 0.01,
                ScreenSize.screenWidth * 0.065,
                ScreenSize.screenHeight * 0.01,
              ), //25,8,8,0
              child: ListTile(
                tileColor: isDarkMode ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
                title: Text(
                  "Grades",
                  style: TextStyle(
                    backgroundColor: isDarkMode ? Colors.black : Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0), //posizione in orizzontale del titolo "Grades"
              ),
            );
          } else {
            final voto = globalData.votiList[index - 2];
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenSize.screenWidth *
                      0.048, // distanza orizzontale dai bordi del dispositivo per quanto riguarda il container dei voti
                  vertical: ScreenSize.screenHeight * 0.007), //15,5
              child: ListTile(
                title: Text(
                  voto.nomeMateria,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(15), //15
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getCircleColor(voto),
                  ),
                  child: Text(
                    voto.voto.toString(),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: ScreenSize.screenWidth * 0.02,
                    vertical: ScreenSize.screenHeight * 0.009),
              ),
            );
          }
        },
      ),
    );
  }
}
