import 'package:flutter/material.dart';
import 'detail_page/detail_content.dart';
import 'detail_page/detail_cover.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  late ScrollController listViewController;
  double appBarHeight = 48;

  @override
  void initState() {
    super.initState();
    listViewController = ScrollController(keepScrollOffset: false);
  }

  @override
  Widget build(BuildContext context) {
    Size mSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: mSize.width,
        height: mSize.height,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeLeft: true,
          removeRight: true,
          removeBottom: true,
          child: ListView(
            controller: listViewController,
            children: [
              Container(
                  height: 2 * mSize.height,
                  child: Hero(
                    tag: "todo",
                    child: Stack(
                      children: [
                        DetailContent(mSize, listViewController, true,
                            initTop: mSize.width,
                            initScale: 1,
                            topFrom: 1,
                            scaleFrom: 1.0),
                        DetailCover(mSize, listViewController, true,
                            initTop: 0,
                            initScale: 1,
                            topFrom: 1,
                            scaleFrom: 1.0),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class ZoomRoute extends PageRouteBuilder {
  final Widget widget;
  ZoomRoute(this.widget)
      : super(
            transitionDuration: Duration(seconds: 2),
            pageBuilder: (
              BuildContext context,
              Animation<double> animation1,
              Animation<double> animation2,
            ) {
              return widget;
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation1,
                Animation<double> animation2,
                Widget child) {
              // 缩放的效果
              return ScaleTransition(
                scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animation1, curve: Curves.fastOutSlowIn)),
                child: child,
              );
            });
}
