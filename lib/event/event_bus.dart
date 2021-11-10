import 'package:event_bus/event_bus.dart';
import "package:mybook/db/db.dart";

EventBus eventBus = EventBus();

class TodoEvent<T> {
  String state;
  String? type;
  T? todo;
  int? index;
  bool? isLast;
  TodoEvent(this.state, this.todo, {this.index, this.isLast, this.type});
}

class DateEvent {
  String state;
  String date;
  String type;
  DateEvent(this.state, this.type, this.date);
}

class RotateEvent {
  String type;
  RotateEvent({required this.type});
}

class SwiperEvent {
  String state;

  SwiperEvent(this.state);
}

class DragDetailEvent {
  String state;
  double? distance;
  DragDetailEvent(this.state, this.distance);
}

class ChangeCoverEvent {
  String cover;
  String? type;
  ChangeCoverEvent(this.cover, {this.type});
}
