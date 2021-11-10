import 'package:flutter/material.dart';
import '../main.dart';

double FOOTER_HEIGHT = 60;
double DATE_CARD_HEIGHT = 120;
double FRACTION = 0.8;

BuildContext context = MyApp.materialKey.currentContext!;
Size mSize = MediaQuery.of(context).size;
double STATE_BAR_HEIGHT = MediaQuery.of(context).padding.top;
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

// class MyWidget extends StatelessWidget {
//   const MyWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     return Text("");
//   }
// }

// Widget m = MyWidget();

double APP_BAR_HEIGHT = STATE_BAR_HEIGHT + 40;
const double ADD_BUTTON_HEIGHT = 50;
