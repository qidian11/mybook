import 'package:moor_flutter/moor_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for moor to know about the generated code
part 'db.g.dart';

// this will generate a table called "todos" for us. The rows of that table will
// be represented by a class called "Todo".
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 32)();
  TextColumn get content => text()();
  TextColumn get cover => text()();
  TextColumn get fileCover => text().nullable()();
  IntColumn get category => integer().nullable()();
  DateTimeColumn get time => dateTime().nullable()();
  BoolColumn get fav => boolean().withDefault(Constant(false))();
}

class DateTodos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 32)();
  TextColumn get content => text()();
  TextColumn get cover => text()();
  TextColumn get fileCover => text().nullable()();
  IntColumn get category => integer().nullable()();
  DateTimeColumn get time => dateTime().nullable()();
  BoolColumn get fav => boolean().withDefault(Constant(false))();
}

@DataClassName("Category")
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text()();
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [Todos, DateTodos, Categories])
class MyDatabase extends _$MyDatabase {
  // we tell the database where to store the data with this constructor
  MyDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: "db.sqlite", logStatements: true));

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 7;

  Future<List<Todo>> getAllTodo() => select(todos).get();
  Stream<List<Todo>> watchAllTodo() => select(todos).watch();
  Future insertNewTodo(TodosCompanion todo) => into(todos).insert(todo);
  Future deleteTodo(Todo todo) => delete(todos).delete(todo);
  Future updateTodo(Todo todo) => update(todos).replace(todo);
  Future getCount() {
    var countExp = todos.id.count();

//Moor creates query from Expression so, they don't have value unless you execute it as query.
//Following query will execute experssion on Table.
    final query = selectOnly(todos)..addColumns([countExp]);
    return query.map((row) => row.read(countExp)).getSingle();
  }

  Future<List<DateTodo>> getAllDateTodo() => select(dateTodos).get();
  Stream<List<DateTodo>> watchAllDateTodo() => select(dateTodos).watch();
  Stream<List<DateTodo>> watchDateTodoFromDate(int year, int month, int day) {
    return (select(dateTodos)
          ..where((row) {
            return row.time.year.equals(year) &
                (row.time.month.equals(month)) &
                (row.time.day.equals(day));
          }))
        .watch();
  }

  Future insertNewDateTodo(DateTodosCompanion todo) =>
      into(dateTodos).insert(todo);
  Future deleteDateTodo(DateTodo todo) => delete(dateTodos).delete(todo);
  Future updateDateTodo(DateTodo todo) => update(dateTodos).replace(todo);
  Future<int> getCountDateTodo() {
    var countExp = dateTodos.id.count();

//Moor creates query from Expression so, they don't have value unless you execute it as query.
//Following query will execute experssion on Table.
    final query = selectOnly(dateTodos)..addColumns([countExp]);
    return query.map((row) => row.read(countExp)).getSingle();
  }

  Future getCountDateTodoFromDate(int year, int month, int day) {
    print("getCountDateTodoFromDate");
    print(day);
    var countExp = dateTodos.id.count();

//Moor creates query from Expression so, they don't have value unless you execute it as query.
//Following query will execute experssion on Table.
    final query = (selectOnly(dateTodos)
      ..where(dateTodos.time.year.equals(year) &
          (dateTodos.time.month.equals(month)) &
          (dateTodos.time.day.equals(day))))
      ..addColumns([countExp]);
    return query.map((row) => row.read(countExp)).getSingle();
  }

  Stream<List> getFavTodo() {
    final todosWatch =
        (select(todos)..where((row) => row.fav.equals(true))).watch();
    // 获取stream中数组长度
    // todosWatch.listen((event) {
    //   print(event.length);
    // });
    final dateTodosWatch =
        (select(dateTodos)..where((row) => row.fav.equals(true))).watch();
    // 获取stream中数组长度
    // dateTodosWatch.listen((event) {
    //   print(event.length);
    // });
    final result = CombineLatestStream.list([dateTodosWatch, todosWatch]);
    return result;
  }

  List getCountFavTodo() {
    var countExp1 = dateTodos.id.count();

//Moor creates query from Expression so, they don't have value unless you execute it as query.
//Following query will execute experssion on Table.
    final query1 = (selectOnly(dateTodos)..where(dateTodos.fav.equals(true)))
      ..addColumns([countExp1]);

    var a = query1.map((row) => row.read(countExp1)).getSingle();
    var countExp2 = todos.id.count();

//Moor creates query from Expression so, they don't have value unless you execute it as query.
//Following query will execute experssion on Table.
    final query2 = (selectOnly(todos)..where(todos.fav.equals(true)))
      ..addColumns([countExp2]);
    var b = query2.map((row) => row.read(countExp2)).getSingle();
    return [a, b];
  }

  @override
  // TODO: implement migration
  MigrationStrategy get migration =>
      MigrationStrategy(onUpgrade: (migrator, from, to) async {
        //from: is the version we are currently running before upgrade
        if (from == 1) {
          // We are telling the database to add the category column so it can be upgraded to version 2
          // await migrator.createTable(favOrLunar);
          // await migrator.createTable(tagList);
        }
        if (from == 2) {
          await migrator.deleteTable("favOrLunar");
          await migrator.deleteTable("tagList");
        }
        if (from == 3) {
          await migrator.createTable(dateTodos);
        }
        if (from == 4) {
          await migrator.createTable(dateTodos);
        }
        if (from == 5) {
          await migrator.addColumn(todos, todos.fileCover);
        }
        if (from == 6) {
          await migrator.addColumn(dateTodos, dateTodos.fileCover);
        }
      });
}
