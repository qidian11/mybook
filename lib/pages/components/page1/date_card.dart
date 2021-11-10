import 'dart:math';

import "package:flutter/material.dart";
import '../../../UI/ui_size.dart';
import '../../../util/lunar_calendar.dart';
import "../../../main.dart";

List<String> weekday = ["", "周一", "周二", "周三", "周四", "周五", "周六", "周日"];
List month = [
  "",
  '一月',
  '二月',
  '三月',
  '四月',
  '五月',
  '六月',
  '七月',
  '八月',
  '九月',
  '十月',
  '十一月',
  '十二月'
];

String digit2(num) {
  if (num < 10) {
    return "0" + num.toString();
  }
  return num.toString();
}

class DateCard extends StatefulWidget {
  const DateCard({Key? key}) : super(key: key);

  @override
  _DateCardState createState() => _DateCardState();
}

class _DateCardState extends State<DateCard> {
  double appBarHeight = 48;
  final fontFamily = 'Segoe';

  @override
  Widget build(BuildContext context) {
    Map lunar = solar2lunar(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    String lunarStr = lunar["_festival"] == null ? "" : lunar["_festival"];

    if (lunar["lMonth"] == 12 && lunar["lDay"] >= 29) {
      DateTime nextDay = DateTime.now().add(Duration(days: 1));
      if (lunar["lYear"] !=
          solar2lunar(nextDay.year, nextDay.month, nextDay.day)["lYear"]) {
        lunarStr = "除夕";
      }
    }
    return Positioned(
        top: 0,
        left: 0,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: DATE_CARD_HEIGHT,
            decoration: BoxDecoration(
              color: Color(0xFF335066),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Stack(
              children: [
                // 左侧日期部分
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    // color: Colors.red,
                    width: mSize.width / 2,
                    height: DATE_CARD_HEIGHT,
                    // padding: EdgeInsets.all(10),
                    child: Stack(children: [
                      // 月份
                      Positioned(
                          left: 20,
                          top: -10,
                          child: Text(
                            digit2(DateTime.now().month),
                            style: TextStyle(
                              fontFamily: fontFamily,
                              letterSpacing: 10,
                              fontSize: 70,
                              foreground: Paint()
                                ..shader = LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    Color(0xFFEEC9AC),
                                    Color(0xFFEF629F),
                                  ],
                                ).createShader(
                                  Rect.fromLTWH(0.0, 0.0, 150.0, 220.0),
                                ),
                            ),
                          )),
                      // 斜线
                      Positioned(
                        left: 100,
                        top: 5,
                        child: Transform.rotate(
                          angle: pi / 7,
                          child: Container(
                            width: 5,
                            height: DATE_CARD_HEIGHT - 10,
                            color: Color(0xFF12416E),
                          ),
                        ),
                      ),
                      // 日期
                      Positioned(
                          right: 30,
                          bottom: 0,
                          child: Text(
                            digit2(DateTime.now().day),
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 58,
                              letterSpacing: 5,
                              foreground: Paint()
                                ..shader = LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    Color(0xFFBC95C6),
                                    Color(0xFF7DC4CC),
                                  ],
                                ).createShader(
                                  Rect.fromLTWH(0.0, 0.0, 150.0, 220.0),
                                ),
                              // fontWeight: FontWeight.w300
                            ),
                          )),
                    ]),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    // color: Colors.red,
                    width: mSize.width / 2,
                    height: DATE_CARD_HEIGHT,
                    padding: EdgeInsets.all(10),
                    child: Stack(children: [
                      Positioned(
                          left: 10,
                          top: 0,
                          child: Text(
                            weekday[DateTime.now().weekday],
                            style: TextStyle(
                              fontSize: 45,
                              fontFamily: "Source Hansans",
                              color: Colors.white,
                            ),
                          )),
                      Positioned(
                          right: 30,
                          bottom: 0,
                          child: Text(
                            "农历" +
                                lunar["IMonthCn"] +
                                lunar["IDayCn"] +
                                " " +
                                lunarStr,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Source Hansans",
                              color: Colors.white,
                            ),
                          )),
                    ]),
                  ),
                ),
              ],
            )));
  }
}
