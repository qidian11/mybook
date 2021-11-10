import 'package:flutter/material.dart';
import 'package:mybook/UI/ui_size.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:mybook/db/db.dart';
import 'package:provider/provider.dart';
import '../../../event/event_bus.dart';
import 'package:shake_widget/controller.dart';
import 'package:shake_widget/shake_widget.dart';
import 'dart:async';

class DetailContent extends StatefulWidget {
  final Size mSize;
  final ScrollController listViewController;
  final double initTop;
  final double initScale;
  final double? topFrom;
  final double? scaleFrom;
  final String? title;
  final String? content;
  final DateTime? time;
  final int? category;
  final bool isNewTodo;

  DetailContent(this.mSize, this.listViewController, this.isNewTodo,
      {this.initTop = 0.0,
      this.initScale = 1.0,
      this.topFrom,
      this.scaleFrom,
      this.title,
      this.content,
      this.time,
      this.category,
      Key? key})
      : super(key: key);

  @override
  _DetailContentState createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent>
    with TickerProviderStateMixin {
  late double _scale = widget.initScale;
  late double scale = _scale;
  late double _top = widget.initTop;
  late double top = _top;
  late double maxHeight = widget.mSize.width;

  // 要保存的todo类型
  String todoType = "todo";
  // 两种类型的todo
  Todo? todo;
  DateTodo? dateTodo;
  late String? cover = "images/hot_air_balloon.jpg";
  String? fileCover = null;

  // 动画初始值
  late double animateTop = (mSize.height -
              APP_BAR_HEIGHT -
              DATE_CARD_HEIGHT -
              FOOTER_HEIGHT -
              mSize.width) /
          2.0 +
      DATE_CARD_HEIGHT +
      APP_BAR_HEIGHT;
  double animateScale = FRACTION;

  late Animation<double> animationTop;
  late AnimationController controllerTop;
  late Animation<double> animationScale;
  late AnimationController controllerScale;
  late StreamSubscription tapListener;
  late StreamSubscription coverListener;

  // 聚焦控制
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();

  // 文本控制器
  late TextEditingController titleController;
  late TextEditingController contentController;

  // 抖动控制
  ShakeController shakeController = ShakeController();

  int mark = 0;

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() {
      if (_focusNode1.hasFocus) {
        // TextField has lost focus
        if (widget.listViewController.offset < widget.mSize.width - 48) {
          widget.listViewController.animateTo(widget.mSize.width - 48,
              duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        }
        ;
      }
    });
    _focusNode2.addListener(() {
      if (_focusNode2.hasFocus) {
        print("has node has node has node");
        // TextField has lost focus
        if (widget.listViewController.offset < widget.mSize.width - 48) {
          widget.listViewController.animateTo(widget.mSize.width - 48,
              duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        }
        ;
      }
    });
    print("widget.title");
    print(widget.title);
    titleController = TextEditingController();
    contentController = TextEditingController();

    controllerTop = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    //使用弹性曲线
    animationTop =
        CurvedAnimation(parent: controllerTop, curve: Curves.easeInOut);
    //图片宽高从0变到300
    animationTop =
        Tween(begin: animateTop, end: widget.mSize.width).animate(animationTop)
          ..addListener(() {
            setState(() {
              top = animationTop.value;
            });
          });
    controllerScale = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    //使用弹性曲线
    animationScale =
        CurvedAnimation(parent: controllerTop, curve: Curves.easeInOut);
    //图片宽高从0变到300
    animationScale =
        Tween(begin: animateScale, end: 1.0).animate(animationScale)
          ..addListener(() {
            setState(() {
              scale = animationScale.value;
              if (scale >= 0.98) {
                maxHeight = widget.mSize.height + mSize.width;
              } else {
                maxHeight = widget.mSize.width;
              }
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              titleController.clear();
              contentController.clear();
            }
          });

    // 监听点击事件
    tapListener = eventBus.on<TodoEvent>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      if (event.state == "tap") {
        print(event.todo.runtimeType.toString());
        todoType = event.type!;
        if (event.todo.runtimeType.toString() == "Todo") {
          todo = event.todo;
        } else {
          dateTodo = event.todo;
        }
        print("content tap content tap content tap");
        setState(() {
          cover = event.todo!.cover;
          fileCover = event.todo!.fileCover;
          titleController.text = event.todo!.title;
          contentController.text = event.todo!.content;
          //启动动画
          controllerTop.forward();
          controllerScale.forward();
        });
      } else if (event.state == "reverse" ||
          event.state == "save_create" ||
          event.state == "save_edit") {
        print(
            "fileCover fileCover fileCover fileCover fileCover fileCover fileCover");
        print(fileCover);
        if (event.state == "save_create") {
          print(
              "titleController.text titleController.text titleController.text titleController.text");
          print(titleController.text);
          print(fileCover);
          if (titleController.text == "" || titleController.text == null) {
            shakeController.shake();
          } else {
            final db = Provider.of<MyDatabase>(context, listen: false);
            print(titleController.text);
            db.insertNewTodo(TodosCompanion(
                cover: moor.Value(cover!),
                fileCover: moor.Value(fileCover),
                title: moor.Value(titleController.text),
                content: moor.Value(contentController.text),
                fav: moor.Value(false),
                time: moor.Value(DateTime.now()),
                category: moor.Value(1)));
          }
        } else if (event.state == "save_edit") {
          if (titleController.text == "" || titleController.text == null) {
            shakeController.shake();
          } else {
            final db = Provider.of<MyDatabase>(context, listen: false);
            if (todoType == "Todo") {
              print("cover cover cover cover ");
              print(cover);
              db.updateTodo(todo!.copyWith(
                cover: cover!,
                fileCover: fileCover,
                title: titleController.text,
                content: contentController.text,
                time: DateTime.now(),
              ));
            } else {
              // 非主页编辑不修改时间
              db.updateDateTodo(dateTodo!.copyWith(
                cover: cover!,
                fileCover: fileCover,
                title: titleController.text,
                content: contentController.text,
              ));
            }
          }
        }

        if (titleController.text == "" || titleController.text == null) {
        } else {
          if (widget.topFrom != null) {
            eventBus.fire(TodoEvent("confirm_save_edit", null));
            print("widget.topFrom widget.topFrom widget.topFrom");
            controllerTop.reverse(from: widget.topFrom);
            controllerScale.reverse(from: widget.scaleFrom);
          } else {
            eventBus.fire(TodoEvent("confirm_save_create", null));
            print(
                "widget.topFrom==null widget.topFrom==null widget.topFrom==null");
            controllerTop.reverse();
            controllerScale.reverse();
            maxHeight = widget.mSize.width;
          }
        }
        //启动动画

      } else if (event.state == "add") {
        setState(() {
          top = widget.mSize.width;
          scale = 1.0;
          maxHeight = widget.mSize.height + mSize.width;
        });
      } else if (event.state == "close") {
        if (widget.isNewTodo) {
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

    eventBus.on<DragDetailEvent>().listen((event) {
      if (event.state == "moving") {
        double totalLength = (widget.mSize.width - animateTop).abs();
        double factor = widget.mSize.width > animateTop ? -1.0 : 1.0;
        double topOffset =
            factor * (event.distance! / animateTop) * totalLength;
        double scaleOffset = (event.distance! / animateTop) * -(1 - FRACTION);
        setState(() {
          top = top + topOffset < animateTop ? animateTop : top + topOffset;
          top = top > widget.mSize.width ? widget.mSize.width : top;
          scale = scale + scaleOffset > 1 ? 1 : scale + scaleOffset;
          scale = scale < FRACTION ? FRACTION : scale;
          if (scale >= 0.98) {
            maxHeight = widget.mSize.height + mSize.width;
          } else {
            maxHeight = widget.mSize.width;
          }
        });
      } else if (event.state == "up_reverse") {
        controllerTop.reverse(
            from: (top - animateTop) / (widget.mSize.width - animateTop).abs());
        controllerScale.reverse(from: (scale - FRACTION) / (1 - FRACTION));
      } else if (event.state == "up_forward") {
        controllerTop.forward(from: top);
        controllerScale.forward(from: scale);
        // controllerTop.forward(
        //     from: (widget.mSize.width - top) /
        //         (widget.mSize.width - animateTop).abs());
        // controllerScale.forward(from: (1 - scale) / 0.25);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 点击时鼠标位置
    double startDy = 0;

    return Positioned(
      top: top,
      left: 0,
      child: Transform.scale(
        origin: Offset(0, 0),
        alignment: Alignment.center,
        scale: scale,
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: maxHeight,
          constraints: BoxConstraints(minHeight: maxHeight),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 100),
          child: Column(
            children: <Widget>[
              ShakeWidget(
                shakeController: shakeController,
                child: TextField(
                  style: TextStyle(fontSize: 20),
                  maxLength: 25,
                  controller: titleController,
                  // controller: TextEditingController.fromValue(TextEditingValue(
                  //     text: widget.title!,
                  //     selection: TextSelection.fromPosition(TextPosition(
                  //         affinity: TextAffinity.downstream,
                  //         offset: widget.title!.length)))),
                  decoration: InputDecoration(
                    labelText: "标题",
                    labelStyle: TextStyle(
                      color: Colors.pink,
                      fontSize: 24,
                    ),
                    hintText: "在此处添加标题",
                    hintStyle: TextStyle(fontSize: 20),
                    // border: InputBorder.none,
                  ),
                  focusNode: _focusNode1,
                ),
              ),
              Container(
                // color: Colors.pinkAccent,
                height: (maxHeight / 2) > 50 ? maxHeight / 2 - 50 : 50,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                // padding: EdgeInsets.all(10),
                // decoration: BoxDecoration(
                //   border: Border.all(color: Color(0xFFCCCCCC)),
                // ),
                child: SingleChildScrollView(
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    controller: contentController,
                    // controller: TextEditingController.fromValue(
                    //     TextEditingValue(
                    //         text: widget.content!,
                    //         selection: TextSelection.fromPosition(TextPosition(
                    //             affinity: TextAffinity.downstream,
                    //             offset: widget.content!.length)))),
                    decoration: InputDecoration(
                      labelText: "正文",
                      labelStyle: TextStyle(
                        color: Colors.pink,
                        fontSize: 24,
                      ),
                      hintText: "在此处输入正文",
                      hintStyle: TextStyle(fontSize: 20),
                      // border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    focusNode: _focusNode2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dispose() {
    //路由销毁时需要释放动画资源
    controllerTop.dispose();
    controllerScale.dispose();
    tapListener.cancel();
    super.dispose();
  }
}
