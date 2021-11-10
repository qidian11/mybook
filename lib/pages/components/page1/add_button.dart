import 'package:flutter/material.dart';
import 'package:mybook/UI/ui_size.dart';
import 'package:mybook/db/db.dart';
import 'package:mybook/pages/add_todo.dart';
import 'dart:math';
import 'package:mybook/Iconfont.dart';
import '../../../event/event_bus.dart';
import "../../../main.dart";
import 'dart:async';

class AddButton extends StatefulWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _scale = 1.0;
  void _addTodo() {
    _controller.forward(from: 0.0);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _animation = Tween(begin: 1.0, end: 150.0).animate(_animation)
      ..addListener(() {
        setState(() {
          _scale = _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Navigator.of(context).push(ZoomRoute(AddTodo()));
          eventBus.fire(TodoEvent("add", null));
          Timer(Duration(milliseconds: 500), () {
            setState(() {
              _scale = 1.0;
            });
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scale,
      child: FloatingActionButton(
        backgroundColor: Color(0xFFFD846C),
        onPressed: _addTodo,
        // child: Image.asset("images/add.png", scale: 0.5),
        child: Icon(
          // Icons.add_outlined,
          Iconfont.tianjia,
          size: 45,
        ),
        // child: Transform.translate(
        //   offset: Offset(1, 0),
        //   child: Transform.rotate(
        //     angle: pi / 4,
        //     child: Icon(
        //       Icons.clear,
        //       size: 60,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
