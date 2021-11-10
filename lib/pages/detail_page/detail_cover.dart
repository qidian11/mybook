import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:mybook/UI/ui_size.dart';

import '../../../event/event_bus.dart';
import 'dart:async';
import 'dart:io';

class DetailCover extends StatefulWidget {
  final Size mSize;
  final ScrollController listViewController;
  final bool isNewTodo;
  final double initTop;
  final double initScale;
  final double? topFrom;
  final double? scaleFrom;
  final String cover;

  DetailCover(this.mSize, this.listViewController, this.isNewTodo,
      {this.cover = "images/hot_air_balloon.jpg",
      this.initTop = 0.0,
      this.initScale = 1.0,
      this.topFrom,
      this.scaleFrom,
      Key? key})
      : super(key: key);

  @override
  _DetailCoverState createState() => _DetailCoverState();
}

class _DetailCoverState extends State<DetailCover>
    with TickerProviderStateMixin {
  late double _top = widget.initTop;
  late double top = _top;
  late double _scale = widget.initScale;
  late double scale = _scale;
  late Animation<double> animationTop;
  late AnimationController controllerTop;
  late Animation<double> animationScale;
  late AnimationController controllerScale;
  late StreamSubscription tapListener;
  late StreamSubscription coverListener;

  double startDy = 0;
  double _startDy = 0;
  double? lastDy = null;
  bool newMoving = false;
  double listViewOffset = 0;

  // 封面图片
  String cover = "images/hot_air_balloon.jpg";
  String? fileCover;

  // 圆角
  double borderRadius = 0.0;
  late AnimationController radiusController;
  late Animation<double> radiusAnimation;

  // 判断是否是滑动事件
  bool isMove = false;

  // 动画初始值
  late double animateTop = (mSize.height -
              APP_BAR_HEIGHT -
              DATE_CARD_HEIGHT -
              FOOTER_HEIGHT -
              widget.mSize.width) /
          2.0 +
      DATE_CARD_HEIGHT +
      APP_BAR_HEIGHT;
  double animateScale = FRACTION;

  @override
  void initState() {
    super.initState();

    controllerTop = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    //使用弹性曲线
    animationTop =
        CurvedAnimation(parent: controllerTop, curve: Curves.easeInOut);

    //
    animationTop = Tween(begin: animateTop, end: 0.0).animate(animationTop)
      ..addListener(() {
        print("#########################################");
        setState(() {
          top = animationTop.value;
        });
        print("top");
        print(top);
        print(animationTop.value);
      })
      ..addStatusListener((state) {
        if (state == AnimationStatus.dismissed) {
          if (widget.topFrom != null) {
            // Navigator.pop(context);
          }
          print("fire end fire end fire end fire end");
          eventBus.fire(TodoEvent("end", null));
        }
      });
    controllerScale = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    animationScale =
        CurvedAnimation(parent: controllerTop, curve: Curves.easeInOut);
    //图片宽高从0变到300
    animationScale =
        Tween(begin: animateScale, end: 1.0).animate(animationScale)
          ..addListener(() {
            setState(() {
              scale = animationScale.value;
            });
          });
    // 圆角动画
    radiusController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    radiusAnimation =
        CurvedAnimation(parent: radiusController, curve: Curves.linear);
    radiusAnimation = Tween(
      begin: 0.0,
      end: 20.0,
    ).animate(radiusAnimation)
      ..addListener(() {
        setState(() {
          borderRadius = radiusAnimation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            borderRadius = 0.0;
          });
        }
      });

    tapListener = eventBus.on<TodoEvent>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      if (event.state == "tap") {
        setState(() {
          cover = event.todo!.cover;
          fileCover = event.todo!.fileCover;
          //启动动画
          controllerTop.forward();
          controllerScale.forward();
        });
      } else if (event.state == "add") {
        setState(() {
          top = 0;
          scale = 1.0;
        });
      } else if (event.state == "close") {
        print("cover close cover close cover close cover close cover close ");
        if (widget.isNewTodo) {
          print("isNewTodo isNewTodo isNewTodo isNewTodo isNewTodo");
          // if (widget.topFrom != null) {
          //   controllerTop.reverse(from: widget.topFrom);
          //   controllerScale.reverse(from: widget.scaleFrom);
          // } else {
          //   controllerTop.reverse();
          //   controllerScale.reverse();
          // }
        } else {
          if (widget.topFrom != null) {
            controllerTop.reverse(from: widget.topFrom);
            controllerScale.reverse(from: widget.scaleFrom);
          } else {
            controllerTop.reverse();
            controllerScale.reverse();
          }
        }
      } else if (event.state == "confirm_save_create" ||
          event.state == "confirm_save_edit") {
        if (widget.topFrom != null) {
          controllerTop.reverse(from: widget.topFrom);
          controllerScale.reverse(from: widget.scaleFrom);
        } else {
          controllerTop.reverse();
          controllerScale.reverse();
        }
      } else if (event.state == "over") {
        setState(() {
          cover = "images/hot_air_balloon.jpg";
          fileCover = null;
        });
      }
    });

    // 监听更换封面事件
    coverListener = eventBus.on<ChangeCoverEvent>().listen((event) {
      if (event.type == null) {
        setState(() {
          cover = event.cover;
          fileCover = null;
        });
      } else {
        setState(() {
          fileCover = event.cover;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.cover);
    DecorationImage image = fileCover == null
        ? DecorationImage(
            image: AssetImage(cover),
            fit: BoxFit.cover,
          )
        : DecorationImage(
            image: FileImage(File(fileCover!)),
            fit: BoxFit.cover,
          );
    return Positioned(
      top: top,
      left: 0,
      child: Listener(
        child: Transform.scale(
          origin: Offset(0, 0),
          alignment: Alignment.center,
          scale: scale,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              // image: DecorationImage(
              //   image: FileImage(File(fileCover!)),
              //   fit: BoxFit.cover,
              // ),
              image: image,
            ),
          ),
        ),
        onPointerDown: (e) {
          // print("onPointerDown");
          // print(e.position.dy);
          startDy = e.position.dy;
          listViewOffset = widget.listViewController.offset;
          newMoving = true;
          print("down");
          print(startDy);
          lastDy = startDy;
        },
        onPointerMove: (e) {
          // print("onVerticalDragDown");
          // print(_.delta);
          // print(_.position.dy);
          // print("startDy");
          // print(startDy);
          print("widget.listViewController.offset");
          // print(widget.listViewController.offset);

          if (e.position.dy > startDy &&
                  (startDy + listViewOffset) < (widget.mSize.width / 3) ||
              top > 0) {
            isMove = true;
            double distance;
            double scaleOffset;
            double factor =
                (animateTop - mSize.width * (1 - FRACTION) / 2) / animateTop;
            distance = lastDy == null
                ? e.position.dy - startDy
                : e.position.dy - lastDy!;

            // distance = distance * factor;

            scaleOffset = (distance / animateTop) * -(1 - FRACTION);
            // scaleOffset =
            //     (distance / (animateTop - mSize.width * (1 - FRACTION) / 2)) *
            //         -(1 - FRACTION);
            eventBus.fire(DragDetailEvent('moving', distance));
            // print("distance");
            // print(distance);
            // print("scaleOffset");
            // print(scaleOffset);
            // print("top");
            // print(top);
            setState(() {
              // scale = scale + scaleOffset > 1 ? 1 : scale + scaleOffset;
              // scale = scale < FRACTION ? FRACTION : scale;
              // top = top > animateTop ? animateTop : top + distance;
              // 如果往上滑
              if (e.position.dy < lastDy!) {
                double preScale = scale;
                scale = scale + scaleOffset > 1 ? 1 : scale + scaleOffset;
                scale = scale < FRACTION ? FRACTION : scale;
                scaleOffset = scale - preScale;
                print(
                    "scaleOffset scaleOffset scaleOffset scaleOffset scaleOffset scaleOffset ");
                print(scaleOffset);
                top = top + distance + mSize.width * scaleOffset / 2;
              } else {
                double preScale = scale;
                scale = scale + scaleOffset > 1 ? 1 : scale + scaleOffset;
                scale = scale < FRACTION ? FRACTION : scale;
                scaleOffset = scale - preScale;
                print(
                    "scaleOffset scaleOffset scaleOffset scaleOffset scaleOffset scaleOffset ");
                print(scaleOffset);
                print(mSize.width * scaleOffset / 2);
                print(top + distance);
                print(top + distance + mSize.width * scaleOffset / 2);
                top = top + distance + mSize.width * scaleOffset / 2;
                top = top > animateTop ? animateTop : top;
              }
            });
            lastDy = e.position.dy;

            // double factor = (e.position.dy - startDy) / (animateTop * 2 / 3) > 1
            //     ? 1
            //     : (e.position.dy - startDy) / (animateTop * 2 / 3);
            // setState(() {
            //   top = factor * animateTop;
            //   scale = 1 - factor * 0.25;
            // });
          }
        },
        onPointerUp: (e) {
          print("up uo up");
          print(e);
          if (isMove) {
            isMove = false;
            lastDy = null;
            print("top");
            print(top);
            // 如果是原大小 不处理
            if (scale != 1.0) {
              if (top > animateTop * 1 / 3) {
                print("!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!!!!!");
                print(scale);
                if (scale == FRACTION) {
                  eventBus.fire(DragDetailEvent('up_reverse', null));
                  controllerTop.reverse(from: 1 - top / animateTop);
                  controllerScale.reverse(
                      from: (scale - FRACTION) / (1 - FRACTION));
                  eventBus.fire(TodoEvent("end", null));
                } else {
                  eventBus.fire(DragDetailEvent('up_reverse', null));
                  controllerTop.reverse(from: 1 - top / animateTop);
                  controllerScale.reverse(
                      from: (scale - FRACTION) / (1 - FRACTION));
                }
              } else {
                eventBus.fire(DragDetailEvent('up_forward', null));
                controllerTop.forward(from: top);
                controllerScale.forward(from: scale);
                // controllerTop.forward(from: top / animateTop);
                // controllerScale.forward(from: (1 - scale) / 0.25);
              }
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    //路由销毁时需要释放动画资源
    controllerTop.dispose();
    controllerScale.dispose();
    tapListener.cancel();
    super.dispose();
  }
}
