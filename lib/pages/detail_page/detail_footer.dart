import "package:flutter/material.dart";
import "package:mybook/event/event_bus.dart";
import 'package:mybook/Iconfont.dart';
import "dart:math";

import "package:images_picker/images_picker.dart";

import '../../UI/ui_size.dart';

List<String> imageList = [
  "images/cats.jpg",
  "images/foot.jpg",
  "images/hen.jpg",
  "images/love.jpg",
  "images/woman.jpg",
  "images/music.jpg",
  "images/hot_air_balloon.jpg",
];

class DetailFooter extends StatefulWidget {
  final ScrollController listViewController;
  const DetailFooter({required this.listViewController, Key? key})
      : super(key: key);

  @override
  _DetailFooterState createState() => _DetailFooterState();
}

class _DetailFooterState extends State<DetailFooter>
    with TickerProviderStateMixin {
  bool offstage = false;

  @override
  Widget build(BuildContext context) {
    return Offstage(
        offstage: false,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: FOOTER_HEIGHT,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
            child: Stack(
              children: [
                Positioned(
                  left: 40,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(
                      Iconfont.tupian,
                      color: Color(0xFFFD846C),
                      size: 40,
                    ),
                    onPressed: () {
                      if (widget.listViewController.offset > 0) {
                        widget.listViewController.animateTo(0,
                            duration: Duration(
                                milliseconds:
                                    widget.listViewController.offset ~/ 1),
                            curve: Curves.easeIn);
                      }
                      showDialog(
                        context: context,
                        barrierColor: Colors.black.withAlpha(180),
                        barrierDismissible: true,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Color(0x00FFFFFF), // 背景色
                            // backgroundColor: Colors.white, // 背景色
                            elevation: 4.0, // 阴影高度
                            insetAnimationDuration:
                                Duration(milliseconds: 300), // 动画时间
                            insetAnimationCurve: Curves.decelerate, // 动画效果
                            insetPadding: EdgeInsets.all(0), // 弹框距离屏幕边缘距离
                            clipBehavior: Clip.hardEdge, // 剪切方式
                            // shape: CircleBorder(
                            //   side: BorderSide(
                            //     width: 2,
                            //     color: Colors.blue,
                            //     style: BorderStyle.solid,
                            //   ),
                            // ),
                            child: ClipPic(),
                            // child: RotateWidget(),
                          );
                        },
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 40,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(
                      Iconfont.quxiao,
                      color: Color(0xFFFD846C),
                      size: 30,
                    ),
                    onPressed: () {
                      eventBus.fire(TodoEvent("close", null));
                    },
                  ),
                ),
              ],
            )));
  }
}

Dialog _customDialog(context, {List<Widget>? children}) {
  return Dialog(
    backgroundColor: Colors.white, // 背景色
    elevation: 4.0, // 阴影高度
    insetAnimationDuration: Duration(milliseconds: 300), // 动画时间
    insetAnimationCurve: Curves.decelerate, // 动画效果
    insetPadding: EdgeInsets.all(30), // 弹框距离屏幕边缘距离
    clipBehavior: Clip.hardEdge, // 剪切方式
    shape: CircleBorder(
      side: BorderSide(
        width: 2,
        color: Colors.blue,
        style: BorderStyle.solid,
      ),
    ),
    child: Container(
        width: 0.9 * MediaQuery.of(context).size.width,
        height: 0.9 * MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius:
          //     BorderRadius.circular(0.45 * MediaQuery.of(context).size.width),
        ),
        child: Stack(
          children: children!,
        )
        // child: GridView(
        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 4, //横轴三个子widget
        //         childAspectRatio: 1.0 //宽高比为1时，子widget
        //         ),
        //     children: items),
        ),
  );
}

List<Widget> items = List.generate(7, (index) {
  return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(imageList[index]),
            fit: BoxFit.cover,
          ),
        ),
      ),
      onTapDown: (e) {},
      onTapUp: (e) {
        eventBus.fire(ChangeCoverEvent(imageList[index]));
        // Navigator.pop(context);
      });
});

class RotateWidget extends StatefulWidget {
  const RotateWidget({Key? key}) : super(key: key);

  @override
  _RotateWidgetState createState() => _RotateWidgetState();
}

class _RotateWidgetState extends State<RotateWidget>
    with SingleTickerProviderStateMixin {
  // 旋转动画
  List transformList = <double>[
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ];
  late AnimationController rotateController;
  late Animation<double> rotateAnimation;
  double radius = 40;
  double top = 5.0;
  late double d = MediaQuery.of(context).size.width * 0.45 - radius - top;
  double theta = pi / 4;

  @override
  void initState() {
    super.initState();
    rotateController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    rotateAnimation =
        CurvedAnimation(parent: rotateController, curve: Curves.easeOut);
    rotateAnimation = Tween(begin: 0.0, end: 2 * pi).animate(rotateAnimation)
      ..addListener(() {
        setState(() {
          for (int i = 0; i < transformList.length; i++) {
            if (transformList[i] < i * pi / 4) {
              transformList[i] = rotateAnimation.value;
            } else {
              transformList[i] = i * pi / 4;
            }
          }
        });
      });
    rotateController.forward();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> picList = List<Widget>.generate(8, (index) {
      return Positioned(
        top: top,
        left: 0,
        right: 0,
        child: Align(
            alignment: Alignment.center,
            child: Transform(
                transform: Matrix4(
                  1.0,
                  0.0,
                  0.0,
                  0.0,
                  0.0,
                  1.0,
                  0.0,
                  0.0,
                  0.0,
                  0.0,
                  1.0,
                  0.0,
                  d * sin(transformList[index]),
                  d - d * cos(transformList[index]),
                  0.0,
                  1.0,
                ),
                child: Transform.rotate(
                  angle: 0,
                  alignment: Alignment.center,
                  // angle: -1.0 * transformList[7],
                  child: CircleAvatar(
                    backgroundImage: AssetImage("images/butt.jpg"),
                    radius: radius,
                  ),
                ))),
      );
    });
    return Container(
        width: 0.9 * MediaQuery.of(context).size.width,
        height: 0.9 * MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius:
          //     BorderRadius.circular(0.45 * MediaQuery.of(context).size.width),
        ),
        child: Stack(
          children: picList,
        )
        // child: GridView(
        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 4, //横轴三个子widget
        //         childAspectRatio: 1.0 //宽高比为1时，子widget
        //         ),
        //     children: items),
        );
  }
}

class ClipPic extends StatefulWidget {
  const ClipPic({Key? key}) : super(key: key);

  @override
  _ClipPicState createState() => _ClipPicState();
}

class _ClipPicState extends State<ClipPic> with SingleTickerProviderStateMixin {
  late AnimationController radiusController;
  late Animation<double> radiusAnimation;
  double r = 0.0;
  @override
  void initState() {
    super.initState();
    radiusController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    radiusAnimation =
        CurvedAnimation(parent: radiusController, curve: Curves.easeOut);
    radiusAnimation = Tween(begin: 0.0, end: 200.0).animate(radiusAnimation)
      ..addListener(() {
        setState(() {
          r = radiusAnimation.value;
        });
      });
    radiusController.forward();
    items.add(
      Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: IconButton(
          icon: Icon(Icons.add),
          iconSize: 40,
          onPressed: () async {
            List<Media>? res = await ImagesPicker.pick(
              count: 1, // 最大可选择数量
              pickType: PickType.image, // 选择媒体类型，默认图片
            );
            print(res);
            print("res res res res res res");
            if (res != null) {
              eventBus.fire(ChangeCoverEvent(res[0].path, type: "fileCover"));
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: RectPath(r),
      child: Container(
        height: 200,
        child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, //横轴三个子widget
                childAspectRatio: 1.0 //宽高比为1时，子widget
                ),
            children: items),
      ),
    );
  }

  @override
  void dispose() {
    radiusController.dispose();
    super.dispose();
  }
}

class RectPath extends CustomClipper<Path> {
  double r;
  RectPath(this.r);
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
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
