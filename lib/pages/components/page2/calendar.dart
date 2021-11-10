import 'package:flutter/material.dart';
import 'package:mybook/UI/ui_size.dart';
import 'package:mybook/pages/components/init_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:mybook/db/db.dart';
import '../../../event/event_bus.dart';
import 'show_date.dart';
import 'dart:async';

class LunarCalendar extends StatefulWidget {
  const LunarCalendar({Key? key}) : super(key: key);

  @override
  _LunarCalendarState createState() => _LunarCalendarState();
}

class _LunarCalendarState extends State<LunarCalendar>
    with TickerProviderStateMixin {
  late Widget showCalendar;
  List<DateTag> tagList = [];
  late InitData initData;
  String showHead = "";
  late int yearRange; //年份范围的开始年份
  late int year;
  late int month;
  late int day;

  // 设置缩放动画
  double scale = 1.0;
  late AnimationController _controllerSmall;
  late Animation<double> _animationSmall;
  late AnimationController _controllerBig;
  late Animation<double> _animationBig;

  // 日历监听器
  late StreamSubscription dateListener;

  void setShowHead() {
    showHead = "";
    if (tagList.length > 1) {
      tagList.forEach((element) {
        if (element.tag != "showYearRange") {
          showHead += element.date;
          if (element.tag == "showYear") {
            showHead += "年";
          } else if (element.tag == "showMonth") {
            showHead += "月";
          } else {
            showHead += "日";
          }
        }
      });
    } else {
      print((int.parse(tagList[0].date) + 11).toString());
      showHead = tagList[0].date +
          ' - ' +
          (int.parse(tagList[0].date) + 11).toString();
    }
    print("showHead");
    print(showHead);
  }

  // Widget setShowDate() {
  //   Widget w;
  //   if (tagList.last.tag == "year") {
  //     List<Widget> items = List.generate(
  //         12, (index) => Text("${index + int.parse(tagList.last.date)}"));
  //     w = GridView(
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 12, //横轴三个子widget
  //             childAspectRatio: 1.0 //宽高比为1时，子widget
  //             ),
  //         children: items);
  //     return w;
  //   }
  //   if (tagList.last.tag == "month") {
  //     List<Widget> items = List.generate(12, (index) => Text("${index + 1}"));
  //     w = GridView(
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 12, //横轴三个子widget
  //             childAspectRatio: 1.0 //宽高比为1时，子widget
  //             ),
  //         children: items);
  //     return w;
  //   }

  //   List<Widget> items = List.generate(31, (index) => Text("${index + 1}"));
  //   w = GridView(
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 31, //横轴三个子widget
  //           childAspectRatio: 1.0 //宽高比为1时，子widget
  //           ),
  //       children: items);

  //   return w;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 监听日历时间
    dateListener = eventBus.on<DateEvent>().listen((event) async {
      DateTag d = DateTag(event.type, event.date);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(event.type, int.parse(event.date));
      setState(() {
        tagList.add(d);

        setShowHead();
      });
      _controllerBig.forward(from: 0.1);
    });

    // 初始化tagList
    // setTagList();
    initData = Provider.of<InitData>(context, listen: false);
    tagList = initData.tagList;
    print("tagList");
    tagList.forEach((e) => print(e.tag));

    // 初始化标题文字
    setShowHead();

    // 初始化缩放动画

    // 缩小动画
    _controllerSmall =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _animationSmall =
        CurvedAnimation(parent: _controllerSmall, curve: Curves.easeOutSine);
    _animationSmall = Tween(begin: 5.0, end: 1.0).animate(_animationSmall)
      ..addListener(() {
        setState(() {
          scale = _animationSmall.value;
          print("scale");
          print(scale);
        });
      });
    // 放大动画
    _controllerBig =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _animationBig =
        CurvedAnimation(parent: _controllerBig, curve: Curves.easeOutSine);
    _animationBig = Tween(begin: 0.1, end: 1.0).animate(_animationBig)
      ..addListener(() {
        setState(() {
          scale = _animationBig.value;
          print("scale");
          print(scale);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Container(
        // color: Colors.lightBlueAccent,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: DATE_CARD_HEIGHT / 2 - 12,
              child: Center(
                  child: TextButton(
                onPressed: () async {
                  // Respond to button press
                  if (tagList.last.tag != "showYearRange") {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove(tagList.last.tag);
                  }
                  if (tagList.length > 1) {
                    setState(() {
                      tagList.removeLast();

                      setShowHead();
                    });
                    _controllerSmall.forward(from: 0.1);
                  }
                },
                child: Text(
                  showHead,
                  style: TextStyle(fontSize: 24),
                ),
              )),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: (mSize.height -
                          APP_BAR_HEIGHT -
                          DATE_CARD_HEIGHT -
                          FOOTER_HEIGHT -
                          FRACTION * mSize.width) /
                      2.0 +
                  DATE_CARD_HEIGHT,
              child: Container(
                // color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                // padding: EdgeInsets.fromLTRB(40, 0, 40, 0),

                child: ShowDate(tagList),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    dateListener.cancel();
    _controllerSmall.dispose();
    _controllerBig.dispose();
    super.dispose();
  }
}
