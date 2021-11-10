import 'package:flutter/material.dart';
import 'package:mybook/pages/components/page1/todo_swiper.dart';
import '../../../event/event_bus.dart';
import '../../../util/lunar_calendar.dart';

Map<int, List<String>> monthDay = const {
  31: ["1", "3", "5", "7", "8", "10", "12"],
  30: ["4", "6", "9", "11"],
};
const List week = [
  Center(
    child: Text("一", style: TextStyle(fontSize: 18, color: Colors.blue)),
  ),
  Center(child: Text("二", style: TextStyle(fontSize: 18, color: Colors.blue))),
  Center(child: Text("三", style: TextStyle(fontSize: 18, color: Colors.blue))),
  Center(child: Text("四", style: TextStyle(fontSize: 18, color: Colors.blue))),
  Center(child: Text("五", style: TextStyle(fontSize: 18, color: Colors.blue))),
  Center(child: Text("六", style: TextStyle(fontSize: 18, color: Colors.blue))),
  Center(child: Text("日", style: TextStyle(fontSize: 18, color: Colors.blue)))
];
List month = [
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

String twoDigets(String num) {
  if (int.parse(num) < 10) {
    num = '0' + num;
  }
  return num;
}

class ShowDate extends StatefulWidget {
  final List tagList;
  const ShowDate(this.tagList, {Key? key}) : super(key: key);

  @override
  _ShowDateState createState() => _ShowDateState();
}

class _ShowDateState extends State<ShowDate> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("widget.tagList.last.tag");
    print(widget.tagList.last.tag);
    if (widget.tagList.last.tag == "showYearRange") {
      List<Widget> items = List.generate(
        12,
        (index) => Container(
          // color: Colors.blue,
          child: Center(
            child: TextButton(
              onPressed: () {
                eventBus.fire(DateEvent('date', "showYear",
                    "${index + int.parse(widget.tagList.last.date)}"));
              },
              child: Text("${index + int.parse(widget.tagList.last.date)}"),
            ),
          ),
        ),
      );
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeLeft: true,
        removeRight: true,
        removeBottom: true,
        child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, //横轴三个子widget
                childAspectRatio: 1.0 //宽高比为1时，子widget
                ),
            children: items),
      );
    }
    if (widget.tagList.last.tag == "showYear") {
      List<Widget> items = List.generate(
          12,
          (index) => Container(
                // color: Colors.blue,
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      eventBus
                          .fire(DateEvent('date', "showMonth", "${index + 1}"));
                    },
                    child: Text(month[index]),
                  ),
                ),
              ));
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeLeft: true,
        removeRight: true,
        removeBottom: true,
        child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 1.0 //宽高比为1时，子widget
                ),
            children: items),
      );
    }
    // 设置月份内的日期
    if (widget.tagList.last.tag == "showMonth") {
      String monthStr;
      // 补全2位月份
      monthStr = twoDigets(widget.tagList.last.date);
      Map m = solar2lunar(2021, 2, 11);
      print("map");
      print(m);
      String dateStr01 = widget.tagList[1].date + "-" + monthStr + "01";
      DateTime time = DateTime.parse(dateStr01);
      int weekday = time.weekday;
      print("weekday");
      print(weekday);

      // 计算月份天数
      int dayLength;
      if (widget.tagList.last.date == "2") {
        int monthNum = int.parse(widget.tagList[1].date);
        if ((monthNum % 4 == 0 && monthNum % 100 != 0) || monthNum % 400 == 0) {
          dayLength = 29;
        } else {
          dayLength = 28;
        }
      } else {
        if (monthDay[31]!.contains(widget.tagList.last.date)) {
          dayLength = 31;
        } else {
          dayLength = 30;
        }
      }

      List<Widget> items = List.generate(dayLength + weekday - 1 + 7, (index) {
        if (index < 7) {
          return week[index];
        }
        if (index < weekday - 1 + 7) {
          return Text("");
        }

        String dayStr;
        // 显示的农历信息
        String lunarStr;

        // 获取农历

        String dateStr = widget.tagList[1].date +
            "-" +
            monthStr +
            twoDigets((index + 1 - weekday + 1 - 7).toString());
        DateTime datetime = DateTime.parse(dateStr);
        Map lunarMap = solar2lunar(datetime.year, datetime.month, datetime.day);
        lunarStr = lunarMap["festival"];
        if (lunarMap["lMonth"] == 12 && lunarMap["lDay"] >= 29) {
          DateTime nextDay = datetime.add(Duration(days: 1));
          if (lunarMap["lYear"] !=
              solar2lunar(nextDay.year, nextDay.month, nextDay.day)["lYear"]) {
            lunarStr = "除夕";
          }
        }

        print(lunarStr);

        // 设置星期数
        if (index < weekday - 1) {
          dayStr = "";
        } else {
          dayStr = "${index + 1 - weekday + 1 - 7}";
        }
        return Container(
          // color: Colors.blue,
          child: Center(
            child: TextButton(
                onPressed: () {
                  if (dayStr.length != 0) {
                    eventBus.fire(DateEvent('date', "showDay", dayStr));
                  }
                },
                child: Column(
                  children: [
                    Text(
                      dayStr,
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      lunarStr,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                )),
          ),
        );
      });
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeLeft: true,
        removeRight: true,
        removeBottom: true,
        child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, //横轴三个子widget
                childAspectRatio: 1.0 //宽高比为1时，子widget
                ),
            children: items),
      );
    }
    return TodoSwiper(
        type: "dateTodo",
        key: ValueKey(2),
        year: widget.tagList[1].date,
        month: widget.tagList[2].date,
        day: widget.tagList[3].date);
  }
}
