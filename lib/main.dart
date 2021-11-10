import 'package:flutter/material.dart';
import 'package:mybook/UI/ui_size.dart';
import 'package:mybook/pages/components/init_data.dart';
import 'pages/page1.dart';
import 'pages/page2.dart';
import 'event/event_bus.dart';
import 'db/db.dart';
import 'pages/detail_page/detail.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => MyDatabase()),
      Provider(create: (_) => InitData()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static GlobalKey<NavigatorState> materialKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    final initData = Provider.of<InitData>(context);
    print(initData.tagList);
    return MaterialApp(
      navigatorKey: MyApp.materialKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }
  late PageController pageController;

  @override
  Widget build(BuildContext context) {
    print(
        "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    Size mSize = MediaQuery.of(context).size;
    double typeHeight = MediaQuery.of(context).padding.top;
    pageController = PageController(keepPage: true)
      ..addListener(() {
        // 判断翻页有没有结束
        int page = pageController.page!.toInt();
        if (pageController.page! - page == 0) {
          eventBus.fire(SwiperEvent("end"));
        } else {
          eventBus.fire(SwiperEvent("moving"));
        }
      });
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   // title: Text(widget.title),
      //   title: Text(typeHeight.toString()),
      // ),
      body: FutureBuilder(
        future: InitData().initState(),
        builder: (context, snapshot) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: mSize.width,
                      height: APP_BAR_HEIGHT,
                      padding: EdgeInsets.only(bottom: 5),
                      // color: Colors.white,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Mybook",
                          style: TextStyle(
                            fontSize: 18,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Color(0xFF99C9CC),
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
                    top: APP_BAR_HEIGHT,
                    left: 0,
                    child: Container(
                      // color: Color(0xFFF0F5FC),
                      color: Color(0xFF223344),
                      width: MediaQuery.of(context).size.width,
                      height:
                          MediaQuery.of(context).size.height - APP_BAR_HEIGHT,
                      child: PageView(
                        controller: pageController,
                        children: [
                          Page1(),
                          Page2(),
                        ],
                        // onPageChanged: (_) {
                        //   print("onPageChanged");
                        //   eventBus.fire(SwiperEvent("end"));
                        // },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    // top: (MediaQuery.of(context).size.height -
                    //             appBarHeight -
                    //             120 -
                    //             100 -
                    //             0.75 * MediaQuery.of(context).size.width) /
                    //         2.0 +
                    //     120 +
                    //     appBarHeight,
                    left: 0,
                    child: Detail(mSize),
                  ),
                ],
              ));
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
