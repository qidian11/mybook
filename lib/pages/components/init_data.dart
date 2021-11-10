import 'package:shared_preferences/shared_preferences.dart';

class DateTag {
  String tag;
  String date;
  DateTag(this.tag, this.date);
}

class InitData {
  List<DateTag> tagList = [];
  String showFavOrLunar = "lunar";
  static InitData? _instance;

  InitData._internal() {
    // 不在内部初始化 手动初始化
    // initState();
  }

  // 手动初始化
  Future initState() async {
    setTagList().then((value) => this.tagList = value);
    setShowFavOrLunar().then((value) => this.showFavOrLunar = value);
    return 123;
  }

  factory InitData() => _getInstance();

  static InitData _getInstance() {
    if (_instance == null) {
      _instance = InitData._internal();
    }
    return _instance!;
  }

  Future<List<DateTag>> setTagList() async {
    if (tagList.length == 0) {
      print("setTagList setTagList setTagList");
      DateTime now = new DateTime.now();
      bool keepAdding = true; //设置标识符 如果本地有保存对应变量 则下一级可以继续添加
      bool first = true; // 第一次设置 可以一直添加并且设置对应数据
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.clear();
      int yearRange = prefs.getInt("showYearRange") ?? now.year;
      DateTag showYearRange = DateTag("showYearRange", yearRange.toString());
      tageList_Add(tagList, showYearRange);
      // tagList.add(showYearRange);
      print(tagList[0]);

      prefs.getInt("showYearRange") == null
          ? keepAdding = false
          : first = false; //yearrange是一直存在的 除非第一次
      if (first) prefs.setInt("showYearRange", yearRange);

      int year = prefs.getInt("showYear") ?? now.year;
      DateTag showYear = DateTag("showYear", year.toString());
      prefs.getInt("showYear") == null ? keepAdding = false : 1;
      if (!keepAdding && !first) return tagList;
      if (first) prefs.setInt("showYear", year);
      tageList_Add(tagList, showYear);
      // tagList.add(showYear);

      int month = prefs.getInt("showMonth") ?? now.month;
      DateTag showMonth = DateTag("showMonth", month.toString());
      prefs.getInt("showMonth") == null ? keepAdding = false : 1;
      if (!keepAdding && !first) return tagList;
      if (first) prefs.setInt("showMonth", month);
      tageList_Add(tagList, showMonth);
      // tagList.add(showMonth);

      int day = prefs.getInt("showDay") ?? now.day;
      DateTag showDay = DateTag("showDay", day.toString());
      prefs.getInt("showDay") == null ? keepAdding = false : 1;
      if (!keepAdding && !first) return tagList;
      if (first) prefs.setInt("showday", day);
      tageList_Add(tagList, showDay);
      // tagList.add(showDay);
      print(tagList);
    }
    return tagList;
  }

  Future setShowFavOrLunar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    showFavOrLunar = prefs.getString('showFavOrLunar') ?? "lunar";
    return showFavOrLunar;
  }
}

void tageList_Add(List<DateTag> tagList, DateTag d) {
  bool mark = true;
  tagList.forEach((tag) {
    if (tag.tag == d.tag) {
      mark = false;
    }
  });
  if (mark) {
    tagList.add(d);
  }
}
