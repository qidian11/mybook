import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'dart:io';
import 'dart:math';

import '../../../event/event_bus.dart';
import '../../../db/db.dart';
import 'package:mybook/main.dart';
import 'package:mybook/UI/ui_size.dart';

import 'package:intl/date_symbol_data_local.dart';

class TodoSwiper extends StatefulWidget {
  final String type; // todo or dateTodo
  final String? year;
  final String? month;
  final String? day;
  const TodoSwiper(
      {this.type = "todo", this.year, this.month, this.day, Key? key})
      : super(key: key);

  @override
  _TodoSwiperState createState() => _TodoSwiperState();
}

class _TodoSwiperState extends State<TodoSwiper>
    with AutomaticKeepAliveClientMixin {
  late PageController pageController;
  double viewportFraction = FRACTION;
  double? pageOffset = 0;
  double _top = 0;
  int pageIndex = 0;
  // double initialPage;

  bool isRotating = false;

  late StreamSubscription todoEventListener;
  late StreamSubscription rotateEventListener;

  @override
  void initState() {
    print(
        "todo swiper initState todo swiper initState todo swiper initState todo swiper initState");
    super.initState();

    // 初始化时区
    initializeDateFormatting("zh-CN");
    pageController = PageController(
        initialPage: 0, viewportFraction: viewportFraction, keepPage: true)
      ..addListener(() {
        setState(() {
          pageOffset = pageController.page;
        });
      });
    // 监听todo事件
    todoEventListener = eventBus.on<TodoEvent>().listen((event) {
      final db = Provider.of<MyDatabase>(context, listen: false);
      if (event.state == "save_create") {
        print("save save save");

        BuildContext context = MyApp.materialKey.currentContext!;
        Timer(Duration(milliseconds: 80), () {
          if (widget.type == "todo") {
            db.getCount().then((e) {
              print("e e e e e e e e e e e e e e e e");
              print(e);
              print("e.length");
              print(e);
              // setState(() {
              //   pageOffset = (e - 1) * 1.0;
              // });

              //callback function
              if (pageController.hasClients) {
                pageController.jumpToPage(e - 1);
              }
            });
          } else if (widget.type == "dateTodo") {
            db.getCountDateTodo().then((e) {
              if (pageController.hasClients) {
                pageController.jumpToPage(e - 1);
              }
            });
          }
        });

        rotateEventListener = eventBus.on<RotateEvent>().listen((event) {
          if (event.type == "begin") {
            setState(() {
              isRotating = true;
            });
          } else if (event.type == "end") {
            setState(() {
              isRotating = false;
            });
          }
        });
        // db.getAllTodo().then((e) {
        //   print("e e e e e e e e e e e e e e e e");
        //   print(e);
        //   print("e.length");
        //   print(e.length);
        //   Timer(Duration(milliseconds: 80), () {
        //     //callback function
        //     pageController!.jumpToPage(e.length - 1);
        //     // pageController!.animateToPage(e.length - 1,
        //     //     duration: Duration(milliseconds: 150),
        //     //     curve: Curves.ease); // 5s之后
        //   });
        // });
      } else if (event.state == "delete") {
        Timer(Duration(milliseconds: 100), () {
          //callback function
          if (event.type == widget.type && event.type == "todo") {
            db.deleteTodo(event.todo!).then((e) {
              setState(() {
                if (event.isLast!) {
                  pageOffset = pageOffset! > 1 ? pageOffset! - 1 : 0;
                }
                // else if (e - 1 > 0) {
                //   print(
                //       "delete e delete e delete e delete e delete e delete e delete e delete e delete e delete e");
                //   print(e);
                //   print("event.index");
                //   print(event.index);
                //   pageOffset = event.index! * 1.0;
                // }
                print(
                    "delete pageOffset delete pageOffset delete pageOffset delete pageOffset delete pageOffset ");
                print(pageOffset);
                if (pageController.hasClients) {
                  pageController.jumpToPage(pageOffset! ~/ 1.0);
                }
              });
            });
            db.insertNewDateTodo(DateTodosCompanion(
              category: moor.Value(event.todo.category),
              fav: moor.Value(event.todo.fav),
              title: moor.Value(event.todo.title),
              content: moor.Value(event.todo.content),
              time: moor.Value(event.todo.time),
              cover: moor.Value(event.todo.cover),
              fileCover: moor.Value(event.todo.fileCover),
            ));
          }
          if (event.type == widget.type && event.type == "dateTodo") {
            db.deleteDateTodo(event.todo!).then((e) {
              setState(() {
                if (event.isLast!) {
                  pageOffset = pageOffset! > 1 ? pageOffset! - 1 : 0;
                }
                //  else if (e - 1 > 0) {
                //   print("e");
                //   print(e);
                //   print("event.index");
                //   print(event.index);
                //   pageOffset = event.index! * 1.0;
                // }

                if (pageController.hasClients) {
                  pageController.jumpToPage(pageOffset! ~/ 1.0);
                }
              });
            });
          }

          // setState(() {
          //   print(
          //       "!!!!!! @@@@@@ before pageoffset before pageoffset before pageoffset before pageoffset");
          //   print(pageOffset);
          //   print(pageController.page);
          //   print(event.isLast);
          //   if (event.isLast!) {
          //     pageOffset = pageOffset! > 1 ? pageOffset! - 1 : 0;
          //   } else if (e - 1 > 0) {
          //     print("e");
          //     print(e);
          //     print("event.index");
          //     print(event.index);
          //     pageOffset = event.index! * 1.0;
          //   }
          //   print(
          //       "delete pageOffset delete pageOffset delete pageOffset delete pageOffset delete pageOffset ");
          //   print(pageOffset);
          //   if (pageController.hasClients) {
          //     pageController.jumpToPage(pageOffset! ~/ 1.0);
          //   }
          // });

          // pageController!.animateToPage(e.length - 1,
          //     duration: Duration(milliseconds: 150),
          //     curve: Curves.ease); // 5s之后
        });
      } else if (event.state == "favDelete") {
        if (event.todo.runtimeType.toString() == "Todo") {
          db.updateTodo(event.todo.copyWith(fav: !event.todo.fav)).then((e) {
            setState(() {
              if (event.isLast!) {
                pageOffset = pageOffset! > 1 ? pageOffset! - 1 : 0;
              }
              //  else if (e - 1 > 0) {
              //   print("e");
              //   print(e);
              //   print("event.index");
              //   print(event.index);
              //   pageOffset = event.index! * 1.0;
              // }

              if (pageController.hasClients) {
                pageController.jumpToPage(pageOffset! ~/ 1.0);
              }
            });
          });
        } else if (event.todo.runtimeType.toString() == "DateTodo") {
          db
              .updateDateTodo(event.todo.copyWith(fav: !event.todo.fav))
              .then((e) {
            setState(() {
              if (event.isLast!) {
                pageOffset = pageOffset! > 1 ? pageOffset! - 1 : 0;
              }
              //  else if (e - 1 > 0) {
              //   print("e");
              //   print(e);
              //   print("event.index");
              //   print(event.index);
              //   pageOffset = event.index! * 1.0;
              // }

              if (pageController.hasClients) {
                pageController.jumpToPage(pageOffset! ~/ 1.0);
              }
            });
          });
        }
      }
      // setState(() {
      //   if (pageOffset! > 0) {
      //     pageOffset = pageOffset! - 1;
      //   }
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final db = Provider.of<MyDatabase>(context, listen: false);
    if (widget.type == "todo") {
      return Container(
        // maxWidth: screenWidth,
        // maxHeight: screenWidth,
        // minHeight: screenWidth,
        // color: Colors.black,
        width: screenWidth,
        height: FRACTION * screenWidth + 20, // 原本的高度加指示器的高度
        child: StreamBuilder(
            stream: db.watchAllTodo(),
            builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
              if (snapshot.data?.length == 0 || !snapshot.hasData) {
                return Center(
                    child: Text("空空如也",
                        style:
                            TextStyle(fontSize: 50, color: Colors.blue[900])));
              }
              return Stack(
                children: [
                  Positioned(
                    top: FRACTION * mSize.width,
                    child: Container(
                      // color: Colors.white,
                      width: mSize.width,
                      height: 14,
                      margin: EdgeInsets.only(top: 6),
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: pageController,
                          // count: snapshot.data!.length > 6
                          //     ? 6
                          //     : snapshot.data!.length,
                          count: snapshot.hasData ? snapshot.data!.length : 0,
                          // effect: WormEffect(
                          //   dotHeight: 10,
                          //   dotWidth: 10,
                          //   dotColor: Color(0xFFCCCCCC),
                          //   activeDotColor: Color(0xFFFD846C),
                          //   type: WormType.thin,
                          //   // strokeWidth: 5,
                          // ),
                          effect: ScrollingDotsEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                            dotColor: Color(0xFFCCCCCC),
                            activeDotColor: Color(0xFFFD846C),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      // color: Colors.purple,
                      width: mSize.width,
                      height: FRACTION * mSize.width,
                      child: PageView.builder(
                        controller: pageController,
                        clipBehavior: Clip.none,
                        // itemCount: pages.length,
                        itemCount: snapshot.hasData ? snapshot.data!.length : 1,
                        // itemCount: pages.length,
                        itemBuilder: (_, index) {
                          // return pages[index % pages.length];
                          // return TodoItem(0, pageOffset);
                          if (!snapshot.hasData) {
                            return Container(
                              color: Colors.white,
                            );
                          }

                          return TodoItem<Todo>(
                            index,
                            pageOffset,
                            snapshot.data![index],
                            type: "todo",
                            key: ValueKey(snapshot.data![index].id),
                            // key: UniqueKey(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
      );
    } else if (widget.type == "dateTodo") {
      print(
          "widget.day widget.day widget.day widget.day widget.day widget.day");
      print(widget.day);
      return Container(
        // maxWidth: screenWidth,
        // maxHeight: screenWidth,
        // minHeight: screenWidth,
        // color: Colors.black,
        width: screenWidth,
        height: FRACTION * screenWidth + 20,
        child: StreamBuilder(
            // stream: db.watchAllDateTodo(),
            stream: db.watchDateTodoFromDate(
              int.parse(widget.year!),
              int.parse(widget.month!),
              int.parse(widget.day!),
            ),
            builder: (context, AsyncSnapshot<List<DateTodo>> snapshot) {
              // if (snapshot.data?.length == 0 ||
              //     !snapshot.hasData && !isRotating) {
              //   return Center(
              //       child: Text("空空如也",
              //           style: TextStyle(fontSize: 50, color: Colors.black)));
              // }
              return Stack(
                children: [
                  Positioned(
                    top: FRACTION * mSize.width,
                    child: Container(
                      width: mSize.width,
                      height: 14,
                      margin: EdgeInsets.only(top: 6),
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: pageController,
                          count: snapshot.hasData ? snapshot.data!.length : 0,
                          // effect: WormEffect(
                          //   dotHeight: 10,
                          //   dotWidth: 10,
                          //   dotColor: Color(0xFFCCCCCC),
                          //   activeDotColor: Color(0xFFFD846C),
                          //   type: WormType.thin,
                          //   // strokeWidth: 5,
                          // ),
                          effect: ScrollingDotsEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                            dotColor: Color(0xFFCCCCCC),
                            activeDotColor: Color(0xFFFD846C),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      // color: Colors.purple,
                      width: mSize.width,
                      height: FRACTION * mSize.width,
                      child: PageView.builder(
                        controller: pageController,
                        clipBehavior: Clip.none,
                        // itemCount: pages.length,
                        itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                        // itemCount: pages.length,
                        itemBuilder: (_, index) {
                          // return pages[index % pages.length];
                          // return TodoItem(0, pageOffset);
                          if (!snapshot.hasData) {
                            return Container(
                              color: Colors.white,
                            );
                          }

                          return TodoItem<DateTodo>(
                            index,
                            pageOffset,
                            snapshot.data![index],
                            type: "dateTodo",
                            key: ValueKey(snapshot.data![index].id),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
      );
    }
    // widget.type == "fav"
    return Container(
      // maxWidth: screenWidth,
      // maxHeight: screenWidth,
      // minHeight: screenWidth,
      // color: Colors.black,
      width: screenWidth,
      height: FRACTION * screenWidth + 20,
      child: StreamBuilder(
          // stream: db.watchAllDateTodo(),
          stream: db.getFavTodo(),
          builder: (context, AsyncSnapshot<List> snapshot) {
            // print("我的收藏 我的收藏 我的收藏 我的收藏 我的收藏");
            // 返回值是一个列表装着两个列表 [[datetodos],[todos]]
            List list = [];
            if (snapshot.hasData && snapshot.data!.length != 0) {
              list = [...snapshot.data![0], ...snapshot.data![1]];
              // print(list);
              snapshot.data!.forEach((e) {
                // print(e);
                // print(e.runtimeType.toString());
              });
            }
            // if (list.length == 0 || !snapshot.hasData && !isRotating) {
            //   return Center(
            //       child: Text("空空如也",
            //           style: TextStyle(fontSize: 50, color: Colors.black)));
            // }
            return Stack(
              children: [
                Positioned(
                  top: FRACTION * mSize.width,
                  child: Container(
                    width: mSize.width,
                    height: 14,
                    margin: EdgeInsets.only(top: 6),
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: list.length,
                        // effect: WormEffect(
                        //   dotHeight: 10,
                        //   dotWidth: 10,
                        //   dotColor: Color(0xFFCCCCCC),
                        //   activeDotColor: Color(0xFFFD846C),
                        //   type: WormType.thin,
                        //   // strokeWidth: 5,
                        // ),
                        effect: ScrollingDotsEffect(
                          dotHeight: 10,
                          dotWidth: 10,
                          dotColor: Color(0xFFCCCCCC),
                          activeDotColor: Color(0xFFFD846C),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    // color: Colors.purple,
                    width: mSize.width,
                    height: FRACTION * mSize.width,
                    child: PageView.builder(
                      controller: pageController,
                      clipBehavior: Clip.none,
                      // itemCount: pages.length,
                      itemCount: list.length,
                      // itemCount: pages.length,
                      itemBuilder: (_, index) {
                        // return pages[index % pages.length];
                        // return TodoItem(0, pageOffset);

                        return TodoItem(
                          index,
                          pageOffset,
                          list[index],
                          type: "fav",
                          key: ValueKey(list[index].id),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    todoEventListener.cancel();
    pageController.dispose();
    super.dispose();
  }
}

class TodoItem<T> extends StatefulWidget {
  final String type;
  final int? index;
  final double? pageOffset;
  final T todo;

  TodoItem(this.index, this.pageOffset, this.todo,
      {this.type = "todo", Key? key})
      : super(key: key);
  // const TodoItem({Key? key, this.index, this.pageOffset}) : super(key: key);

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> with TickerProviderStateMixin {
  // int? ind;
  // double? pageOffset;

  late AnimationController _controller;
  late Animation<double> animation;
  double top = 0.0;
  bool offstage = false;
  late StreamSubscription swiperListener;
  late StreamSubscription todoListener;

  late double scale;

  // 删除时动画相关
  double left = 0.0;
  late AnimationController _controllerLeft;
  late Animation<double> animationLeft;

  late AnimationController _controllerRight;
  late Animation<double> animationRight;
  bool isSwiperScale = true;

  // 收藏图标
  double favOffsetY = 0.0;
  double favScaleX = 1.0;
  double favScaleY = 1.0;
  int favAnimationTime = 150;
  late AnimationController _controllerFav;
  late Animation<double> animationFav;

  // late Animation _animation;
  void _runAnimation() {
    // _animation = _controller.drive(
    //   Tween(begin: top, end: 0),
    // );

    _controller = AnimationController(
        duration: Duration(milliseconds: top.abs() ~/ 2), vsync: this);
    animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    animation = Tween(begin: top, end: 0.0).animate(animation)
      ..addListener(() {
        setState(() {
          top = animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.dispose();
        }
      });
    _controller.forward();
  }

  @override
  void initState() {
    super.initState();

    // 监听页面滑动
    swiperListener = eventBus.on<SwiperEvent>().listen((event) {
      if (widget.index != widget.pageOffset) {
        if (event.state == "moving") {
          setState(() {
            offstage = true;
          });
        }
      }
      if (event.state == "end" && offstage == true) {
        setState(() {
          offstage = false;
        });
      }
    });

    // 删除动画
    _controllerLeft =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    animationLeft =
        CurvedAnimation(parent: _controllerLeft, curve: Curves.easeIn);
    animationLeft = Tween(begin: 0.0, end: mSize.width * -1 * FRACTION)
        .animate(animationLeft)
      ..addListener(() {
        setState(() {
          isSwiperScale = false;
          left = animationLeft.value;
          scale = 0.9 + animationLeft.value / (mSize.width * -FRACTION) * 0.1;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            isSwiperScale = true;
          });
        }
      });

    // 左侧Todo向右移时，因为有缓存，所以会保留left值 因此动画结束要复位left值
    _controllerRight =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    animationRight =
        CurvedAnimation(parent: _controllerRight, curve: Curves.easeIn);
    animationRight = Tween(begin: 0.0, end: mSize.width * FRACTION)
        .animate(animationRight)
      ..addListener(() {
        setState(() {
          isSwiperScale = false;
          left = animationRight.value;
          scale = 0.9 + animationLeft.value / (mSize.width * FRACTION) * 0.1;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            left = 0;
            isSwiperScale = true;
          });
        }
      });

    // 监听删除动作
    todoListener = eventBus.on<TodoEvent>().listen((event) {
      if ((event.state == "delete" || event.state == "favDelete") &&
          widget.type == event.type) {
        print(widget.index);
        if (event.isLast!) {
          if (widget.index == (event.index! - 1)) {
            _controllerRight.forward();
          }
        } else {
          if (widget.index == (event.index! + 1)) {
            _controllerLeft.forward();
          }
        }
      }
    });

    // 收藏动画
    _controllerFav = AnimationController(
        duration: Duration(milliseconds: favAnimationTime), vsync: this);
    animationFav =
        CurvedAnimation(parent: _controllerFav, curve: Curves.easeOut);
    animationFav = Tween(begin: 0.0, end: 80.0).animate(animationFav)
      ..addListener(() {
        setState(() {
          favOffsetY = animationFav.value;
          favScaleY = 1 + (animationFav.value / 80.0) * 0.4;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controllerFav.reverse();
        }
        if (status == AnimationStatus.dismissed) {}
      });
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MyDatabase>(context, listen: false);
    if (isSwiperScale) {
      scale = 1 - (widget.pageOffset! - widget.index!).abs() * 0.1;
    }
    // 设置显示封面 cover or fileCover
    DecorationImage image = widget.todo.fileCover == null
        ? DecorationImage(
            image: AssetImage(widget.todo.cover),
            fit: BoxFit.cover,
          )
        : DecorationImage(
            image: FileImage(File(widget.todo.fileCover!)),
            fit: BoxFit.cover,
          );

    return Offstage(
      offstage: offstage,
      child: Transform.scale(
        // scale: 1,
        scale: scale,
        child: Transform.translate(
            offset: Offset(left, top),
            child: GestureDetector(
              child: Container(
                // color: Colors.white,
                // color: Color.fromRGBO(Random().nextInt(256),
                //     Random().nextInt(256), Random().nextInt(256), 1),
                width: MediaQuery.of(context).size.width * FRACTION,
                height: MediaQuery.of(context).size.width * FRACTION,
                // height: 0.75 * MediaQuery.of(context).size.width,
                // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                // height: 280,
                child: Stack(
                  children: [
                    Container(
                      // color: Colors.white,
                      // color: Color.fromRGBO(Random().nextInt(256),
                      //     Random().nextInt(256), Random().nextInt(256), 1),
                      width: MediaQuery.of(context).size.width * FRACTION,
                      height: MediaQuery.of(context).size.width * FRACTION,
                      // height: 0.75 * MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: image,
                        // image: DecorationImage(
                        //   image: AssetImage(widget.todo.cover),
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      // height: 280,
                      // child: Image(
                      //   image: AssetImage("images/butt.jpg"),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    Positioned(
                      child: Center(
                          child: Text(
                        widget.todo.title,
                        style: TextStyle(color: Colors.indigo, fontSize: 20),
                      )),
                    ),
                    Positioned(
                        top: 20,
                        right: 20,
                        child: Offstage(
                            offstage: !widget.todo.fav,
                            child: Transform.translate(
                              offset: Offset(0.0, favOffsetY),
                              child: Transform(
                                transform: Matrix4.identity()
                                  ..scale(favScaleX, favScaleY, 1.0),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.favorite,
                                  size: 40,
                                  color: Color(0xCCFD846C),
                                ),
                              ),
                            ))),
                  ],
                ),
              ),

              onTap: () {
                // print("onTap");
                print(
                    "swiper tap swiper tap swiper tap swiper tap swiper tap swiper tap swiper tap swiper tap swiper tap swiper tap swiper tap ");
                print(widget.todo);
                print(widget.todo.time.day);
                if (widget.index == widget.pageOffset) {
                  eventBus.fire(TodoEvent("tap", widget.todo,
                      type: widget.todo.runtimeType.toString()));
                }
              },
              onPanDown: (DragDownDetails e) {
                //打印手指按下的位置(相对于屏幕)
                // print("用户手指按下：${e.globalPosition}");
              },
              //手指滑动时会触发此回调
              onPanUpdate: (DragUpdateDetails e) {
                //用户手指滑动时，更新偏移，重新构建
                // print("滑动");
                // print(widget.pageOffset);
                // print(widget.todo.runtimeType.toString());
                if (widget.pageOffset == widget.index) {
                  setState(() {
                    top += e.delta.dy;
                  });
                }
              },
              onPanEnd: (DragEndDetails e) {
                print("top");
                print(top);
                // 收藏todo
                if (widget.type != "fav") {}
                if (top > 50) {
                  if (widget.type != "fav") {
                    if (!widget.todo.fav) {
                      if (widget.todo.runtimeType.toString() == "Todo") {
                        db.updateTodo(
                            widget.todo.copyWith(fav: !widget.todo.fav));
                      } else {
                        db.updateDateTodo(
                            widget.todo.copyWith(fav: !widget.todo.fav));
                      }
                    } else {
                      Timer(
                          Duration(
                              milliseconds:
                                  max(top.abs() ~/ 2, favAnimationTime * 2)),
                          () {
                        if (widget.todo.runtimeType.toString() == "Todo") {
                          db.updateTodo(
                              widget.todo.copyWith(fav: !widget.todo.fav));
                        } else if (widget.todo.runtimeType.toString() ==
                            "DateTodo") {
                          db.updateDateTodo(
                              widget.todo.copyWith(fav: !widget.todo.fav));
                        }
                      });
                    }
                  }

                  _runAnimation();
                  _controllerFav.forward();
                  if (widget.type == "fav") {
                    bool isLast = false;
                    Timer(
                        Duration(
                            milliseconds:
                                max(top.abs() ~/ 2, favAnimationTime * 2)), () {
                      setState(() {
                        offstage = true;
                      });
                      var el = db.getCountFavTodo();
                      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
                      el[0].then((e0) {
                        el[1].then((e1) {
                          isLast = e0 + e1 - 1 == widget.index;
                          eventBus.fire(TodoEvent(
                            "favDelete",
                            widget.todo,
                            index: widget.index,
                            isLast: isLast,
                            type: widget.type,
                          ));
                        });
                      });
                    });
                  }
                }
                // 移动超过50 删除todo
                else if (top < -50) {
                  // 不是收藏界面 执行删除动画
                  if (widget.type != "fav") {
                    setState(() {
                      offstage = true;
                    });
                    if (widget.type == "todo") {
                      db.getCount().then((e) {
                        bool isLast = (e - 1) == widget.index ? true : false;
                        eventBus.fire(TodoEvent(
                          "delete",
                          widget.todo,
                          index: widget.index,
                          isLast: isLast,
                          type: widget.type,
                        ));
                      });
                    } else if (widget.type == "dateTodo") {
                      print(widget.todo);
                      db
                          .getCountDateTodoFromDate(
                        widget.todo.time.year,
                        widget.todo.time.month,
                        widget.todo.time.day,
                      )
                          .then((e) {
                        print("dateTodo count");
                        print(e);
                        bool isLast = (e - 1) == widget.index ? true : false;
                        eventBus.fire(TodoEvent(
                          "delete",
                          widget.todo,
                          index: widget.index,
                          isLast: isLast,
                          type: widget.type,
                        ));
                      });
                    }
                  } else {
                    _runAnimation();
                  }
                } else {
                  _runAnimation();
                }

                //打印滑动结束时在x、y轴上的速度
                // print(e.velocity);
                // print(e);
              },
            )),
      ),
    );
  }

  dispose() {
    //路由销毁时需要释放动画资源

    swiperListener.cancel();
    todoListener.cancel();
    _controllerLeft.dispose();
    _controllerRight.dispose();
    // _controller.dispose(); _controller不需要在这里回收
    _controllerFav.dispose();
    super.dispose();
  }
}
