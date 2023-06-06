import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../globals.dart';
import '../data.dart';
import '../providers/themeProvider.dart';
import '../screen_size.dart';
import '../widgets/average.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Voti extends StatefulWidget {
  const Voti({Key? key}) : super(key: key);

  @override
  State<Voti> createState() => _VotiState();
}

class _VotiState extends State<Voti> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ScreenSize.init(context);
  }

  Future<void> _handleRefresh() async {
    Data newData = Data.fromCredentials(globalData.username, globalData.password);
    await newData.initialize();
    setState(() {
      globalData = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    // gets if it's in dark mode or not
    return Consumer<ThemeModel>(builder: (context, model, child) {
      return Scaffold(
        backgroundColor: model.isDarkMode ? Colors.black : Colors.white,
        body: LiquidPullToRefresh(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          color: model.isDarkMode ? Colors.black : Colors.white,
          showChildOpacityTransition: false,
          animSpeedFactor: 2,
          backgroundColor: darkRedITS,
          height: 150,
          //Lista dei voti
          child: ListView.builder(
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
                    tileColor: model.isDarkMode ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: model.isDarkMode ? Colors.black : Colors.white,
                      ),
                    ),
                    title: Text(
                      "Voti",
                      style: TextStyle(
                        backgroundColor:
                            model.isDarkMode ? Colors.black : Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: ScreenSize.screenWidth * 0,
                        vertical: ScreenSize.screenHeight *
                            0), //posizione in orizzontale del titolo "Grades"
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
                    tileColor: model.isDarkMode
                        ? tileBackgroundDarkMode
                        : tileBackgoundLightMode,
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
        ),
      );
    });
  }
}
