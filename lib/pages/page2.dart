import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mybook/event/event_bus.dart';
import 'package:mybook/pages/components/init_data.dart';
import 'package:mybook/pages/components/page1/todo_swiper.dart';
import "components/page2/calendar.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import "package:mybook/UI/ui_size.dart";
import "package:mybook/db/db.dart";
import "package:mybook/Iconfont.dart";
import "dart:math";

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  double scale = 1.0;
  BoxBorder? border = null;
  // 缩放动画
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  // 旋转动画
  late AnimationController rotateController;
  late Animation<double> rotateAnimation;
  int scaleTime = 200;
  int rotateTime = 300;
  // double lunarAngle = 0.0;
  // double favAngle = -pi;
  // bool lunarOffstage = false;
  // bool favOffstage = true;
  double lunarAngle = pi;
  double favAngle = 0.0;
  bool lunarOffstage = true;
  bool favOffstage = false;

  @override
  void initState() {
    super.initState();

    // 设置界面显示收藏还是日历
    final initData = Provider.of<InitData>(context, listen: false);
    if (initData.showFavOrLunar == "fav") {
      lunarAngle = pi;
      favAngle = 0.0;
      lunarOffstage = true;
      favOffstage = false;
    } else {
      lunarAngle = 0.0;
      favAngle = -pi;
      lunarOffstage = false;
      favOffstage = true;
    }

    scaleController = AnimationController(
        duration: Duration(milliseconds: scaleTime), vsync: this);
    scaleAnimation =
        CurvedAnimation(parent: scaleController, curve: Curves.easeOut);
    scaleAnimation = Tween(begin: 1.0, end: 0.75).animate(scaleAnimation)
      ..addListener(() {
        setState(() {
          scale = scaleAnimation.value;
          if (border == null) {
            border = Border.all(color: Color(0xFF34569a));
          }
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          eventBus.fire(RotateEvent(type: "end"));
          setState(() {
            border = null;
          });
        }
      });
    rotateController = AnimationController(
        duration: Duration(milliseconds: rotateTime), vsync: this);
    rotateAnimation =
        CurvedAnimation(parent: rotateController, curve: Curves.easeOut);
    rotateAnimation = Tween(begin: 0.0, end: pi).animate(rotateAnimation)
      ..addListener(() {
        setState(() {
          lunarAngle = rotateAnimation.value;
          print(lunarAngle);
          bool state = lunarOffstage;
          if (lunarAngle > pi / 2 && !state) {
            lunarOffstage = true;
          } else if (lunarAngle < pi / 2 && state) {
            lunarOffstage = false;
          }
          favAngle = -pi + rotateAnimation.value;
          if (favAngle > -pi / 2 && favOffstage) {
            favOffstage = false;
          } else if (favAngle < -pi / 2 && !favOffstage) {
            favOffstage = true;
          }
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          scaleController.reverse();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MyDatabase>(context, listen: false);
    // var parsedDate = DateTime.parse('1974-03-20');
    // print("parsedDate.toString()");
    // print(parsedDate.toString());
    // var year = parsedDate.year;
    // print(year.runtimeType.toString());
    return Stack(children: [
      // 日历界面
      Transform.scale(
        scale: scale,
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(lunarAngle),
          alignment: Alignment.center,
          child: Offstage(
            offstage: lunarOffstage,
            child: Container(
              height: mSize.height - FOOTER_HEIGHT - APP_BAR_HEIGHT,
              decoration: BoxDecoration(
                  border: border, borderRadius: BorderRadius.circular(20)),
              child: LunarCalendar(),
            ),
          ),
        ),
      ),
      // 收藏界面
      Transform.scale(
        scale: scale,
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(favAngle),
          alignment: Alignment.center,
          child: Offstage(
              offstage: favOffstage,
              child: Container(
                width: mSize.width,
                height: mSize.height - FOOTER_HEIGHT - APP_BAR_HEIGHT,
                decoration: BoxDecoration(
                    border: border, borderRadius: BorderRadius.circular(20)),
                child: Stack(children: [
                  Positioned(
                    top: DATE_CARD_HEIGHT / 2 - 20,
                    child: Container(
                      width: mSize.width,
                      child: Center(
                        child: Text(
                          "我的收藏",
                          style: TextStyle(
                            fontSize: 40,
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
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: (mSize.height -
                                APP_BAR_HEIGHT -
                                DATE_CARD_HEIGHT -
                                FOOTER_HEIGHT -
                                FRACTION * mSize.width) /
                            2.0 +
                        DATE_CARD_HEIGHT,
                    child: TodoSwiper(
                      type: "fav",
                    ),
                  ),
                ]),
              )),
        ),
      ),
      Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: FOOTER_HEIGHT,
            child: Stack(
              children: [
                Positioned(
                  left: 40,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(
                      Iconfont.rili,
                      color: Color(0xFFFD846C),
                      size: 30,
                    ),
                    onPressed: () async {
                      if (favAngle == 0) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('showFavOrLunar', "lunar");
                        scaleController.forward();
                        eventBus.fire(RotateEvent(type: "begin"));
                        Timer(Duration(milliseconds: scaleTime), () {
                          rotateController.reverse(from: 1.0);
                        });
                      }
                    },
                  ),
                ),
                Positioned(
                  right: 40,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Color(0xFFFD846C),
                      size: 30,
                    ),
                    onPressed: () async {
                      if (lunarAngle == 0) {
                        eventBus.fire(RotateEvent(type: "begin"));
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('showFavOrLunar', "fav");
                        scaleController.forward();
                        Timer(Duration(milliseconds: scaleTime), () {
                          rotateController.forward();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
