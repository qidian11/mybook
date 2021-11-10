import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:mybook/UI/ui_size.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'dart:math';

import '../../../event/event_bus.dart';
import 'package:mybook/db/db.dart';
import 'detail_cover.dart';
import 'detail_content.dart';
import 'detail_footer.dart';
import 'dart:async';

class Detail extends StatefulWidget {
  static Detail? _instance;
  final Size mSize;

  Detail._internal(this.mSize);

  // 工厂构造函数
  factory Detail(mSize) {
    if (_instance == null) {
      _instance = Detail._internal(mSize);
    }

    return _instance!;
  }

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState<T extends Todo> extends State<Detail>
    with TickerProviderStateMixin {
  bool offstage = true;
  // listview 控制器
  late ScrollController listViewController;
  late StreamSubscription offstageListener;

  // 新建Todo时缩放动画
  late Animation<double> animation;
  late AnimationController controller;

  double oldScrollPos = 0;
  late double initTopCover = (mSize.height -
              APP_BAR_HEIGHT -
              DATE_CARD_HEIGHT -
              FOOTER_HEIGHT -
              widget.mSize.width) /
          2.0 +
      DATE_CARD_HEIGHT +
      APP_BAR_HEIGHT;
  late double initTopContent = initTopCover;
  late double initScale = FRACTION;
  double? topFrom = null;
  double? scaleFrom = null;

  // 取消新建标识符
  bool cancel = true;

  // 新建Todo时的缩放大小
  double scale = 1;

  // 是否是新建todo
  bool isNewTodo = true;
  // 编辑类型 新增为create 编辑为edit
  String editType = "create";

  // 取消新建todo动画
  late AnimationController sizeController;
  late Animation<double> sizeAnimation;
  double heightFactor = sqrt(pow(mSize.width, 2) + pow(mSize.height / 2, 2));

  static TodosCompanion NewTodo = TodosCompanion();

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = Tween(begin: 0.1, end: 1.0).animate(animation)
      ..addListener(() {
        setState(() {
          scale = animation.value;
        });
      });

    // 取消新建动画
    sizeController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    sizeAnimation =
        CurvedAnimation(parent: sizeController, curve: Curves.easeOut);
    sizeAnimation = Tween(
            // begin: sqrt(pow(mSize.width, 2) + pow(mSize.height / 2, 2)),
            begin: mSize.height / 2,
            end: 1.0)
        .animate(sizeAnimation)
      ..addListener(() {
        setState(() {
          heightFactor = sizeAnimation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            offstage = true;
            heightFactor = mSize.height * 2;
          });
          listViewController.jumpTo(0);
          eventBus.fire(TodoEvent('over', null));
        }
      });

    listViewController = ScrollController(keepScrollOffset: false)
      ..addListener(() {
        // print(listViewController.offset);
        // if (listViewController.offset >= widget.mSize.width &&
        //     oldScrollPos < listViewController.offset) {
        //   print("-----------------------");
        //   listViewController.jumpTo(widget.mSize.width);
        // }
        oldScrollPos = listViewController.offset;
      });
    offstageListener = eventBus.on<TodoEvent>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      if (event.state == "tap" || event.state == "end") {
        setState(() {
          if (event.state == "tap") {
            isNewTodo = false;
            print("detail todo");
            offstage = false;

            editType = "edit";
          } else {
            print("detail end detail end detail end");
            if (isNewTodo && cancel == true) {
              print("null null null null null");
              sizeController.forward(from: 0);
            } else {
              Timer(Duration(milliseconds: 90), () {
                setState(() {
                  offstage = true;
                  eventBus.fire(TodoEvent('over', null));
                });
              });

              cancel = true;
            }
          }
          //启动动画
        });
      } else if (event.state == "add") {
        setState(() {
          initTopContent = widget.mSize.width;
          initTopCover = 0;
          initScale = 1.0;
          topFrom = 1.0;
          scaleFrom = 1.0;
          offstage = false;
          isNewTodo = true;
          editType = "create";
        });
        controller.forward(from: 0.0);
      } else if (event.state == "close") {
        if (isNewTodo) {
          sizeController.forward(from: 0);
        } else {
          listViewController.animateTo(0,
              duration: Duration(milliseconds: 100), curve: Curves.easeOut);
        }
      }
    });
  }

  Drag? drag;
  DragStartDetails? dragStartDetails;

  bool onEdge = false;

  bool handleNotification(ScrollNotification notification) {
    final ScrollMetrics metrics = notification.metrics;

    if (metrics.axis == Axis.vertical) {
      if (notification is ScrollEndNotification) {
        //drag = null;

        onEdge = metrics.atEdge;
//        if(metrics.atEdge){
//          log(' at edge');
//          if(drag == null ){
//            drag = pageController.position.drag(dragStartDetails, () {
//              //drag = null;
//            });
//            drag.cancel();
//          }
//        }
        return true;
      }
      if (notification is ScrollStartNotification) {
        onEdge = metrics.atEdge;
        if (notification.dragDetails == null) return true;
        dragStartDetails = notification.dragDetails;
        print("dragStartDetails dragStartDetails");
        print(dragStartDetails!.globalPosition);
        return true;
      }
      if (notification is ScrollUpdateNotification) {
        onEdge = metrics.atEdge;
      }
      if (notification is OverscrollNotification) {
//        if(notification.dragDetails == null) return true;
//        drag.update(notification.dragDetails);
        print("dragStartDetails dragStartDetails");
        print(dragStartDetails!.globalPosition);
        if (!onEdge ||
            (dragStartDetails!.globalPosition.dy + listViewController.offset) <
                mSize.width) return true;
        print("dragStartDetails dragStartDetails");
        print(dragStartDetails!.globalPosition);
        drag = listViewController.position.drag(dragStartDetails!, () {
          //drag = null;
        });
        onEdge = false;
      }

      ///滑动到边缘，例如最小边缘时，继续向右滑动，此时不会触发update
      ///只会触发 start和 end
//      if(notification is ScrollUpdateNotification){
//        log('update');
////        log('after  : ${metrics.extentAfter}');
////        log('before : ${metrics.extentBefore}');
//      }

//      if(notification is UserScrollNotification){
//        log('user');
//        if(metrics.pixels == metrics.minScrollExtent && notification.direction == ScrollDirection.forward){
//          if(drag == null ){
//            drag = pageController.position.drag(dragStartDetails, () {
//              drag = null;
//            });
//          }
//
//        }else if(metrics.pixels == metrics.maxScrollExtent && notification.direction == ScrollDirection.reverse){
//          if(drag == null ){
//            drag = pageController.position.drag(dragStartDetails, () {
//              drag = null;
//            });
//          }
//        }
//
//      }

    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // 点击时鼠标位置
    double startDy = 0;

    return ClipPath(
      clipper: TrianglePath(heightFactor),
      child: Offstage(
        offstage: offstage,
        child: Transform.scale(
          scale: scale,
          child: Container(
            width: widget.mSize.width,
            height: widget.mSize.height,
            child: Stack(
              children: [
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeLeft: true,
                  removeRight: true,
                  removeBottom: true,
                  child: NotificationListener<ScrollNotification>(
                    child: ListView(
                      controller: listViewController,
                      children: [
                        Container(
                          height: 2 * widget.mSize.height,
                          child: Stack(
                            children: [
                              DetailContent(
                                widget.mSize,
                                listViewController,
                                (isNewTodo),
                                initTop: initTopContent,
                                initScale: initScale,
                                topFrom: topFrom,
                                scaleFrom: scaleFrom,
                              ),
                              DetailCover(
                                  widget.mSize, listViewController, (isNewTodo),
                                  initTop: initTopCover,
                                  initScale: initScale,
                                  topFrom: topFrom,
                                  scaleFrom: scaleFrom),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onNotification: handleNotification,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: DetailFooter(listViewController: listViewController),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: FOOTER_HEIGHT - APP_BAR_HEIGHT / 2.0,
                  child: Center(
                    // FloatingActionButton的大小会自动扩展至父容器 因此要加以限制
                    child: Container(
                      // color: Colors.amber,
                      width: 80,
                      child: FloatingActionButton(
                        backgroundColor: Color(0xFFFD846C),
                        onPressed: () {
                          // _saveTodo(context);
                          cancel = false;
                          listViewController.animateTo(0,
                              duration: Duration(milliseconds: 100),
                              curve: Curves.easeOut);
                          Timer(Duration(milliseconds: 100), () {
                            if (editType == "create") {
                              eventBus.fire(TodoEvent("save_create", null));
                            } else {
                              eventBus.fire(TodoEvent("save_edit", isNewTodo));
                            }
                          });
                        },
                        child: Icon(Icons.done, size: APP_BAR_HEIGHT / 1.5),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  dispose() {
    //路由销毁时需要释放动画资源
    offstageListener.cancel();
    super.dispose();
  }
}

class TrianglePath extends CustomClipper<Path> {
  double r;
  TrianglePath(this.r);
  @override
  Path getClip(Size size) {
    var path = Path();
    // path.moveTo(size.width / 2, 0);
    // path.lineTo(0, size.height);
    // path.lineTo(size.width, size.height);

    // 圆形裁剪
    // double mr = r < size.width / 2 ? size.width / 2 : r;
    // path.addOval(Rect.fromLTWH(0, size.height / 2 - r, 2 * mr, 2 * r));

    // 矩形裁剪
    path.addRect(Rect.fromLTWH(0, size.height / 2 - r, size.width, 2 * r));

    // path.addOval(Rect.fromCircle(
    //   center: Offset(r, size.width / 2),
    //   radius: r,
    // ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
