// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Todo extends DataClass implements Insertable<Todo> {
  final int id;
  final String title;
  final String content;
  final String cover;
  final String? fileCover;
  final int? category;
  final DateTime? time;
  final bool fav;
  Todo(
      {required this.id,
      required this.title,
      required this.content,
      required this.cover,
      this.fileCover,
      this.category,
      this.time,
      required this.fav});
  factory Todo.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Todo(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      content: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}content'])!,
      cover: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cover'])!,
      fileCover: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}file_cover']),
      category: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}category']),
      time: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}time']),
      fav: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fav'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['cover'] = Variable<String>(cover);
    if (!nullToAbsent || fileCover != null) {
      map['file_cover'] = Variable<String?>(fileCover);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<int?>(category);
    }
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<DateTime?>(time);
    }
    map['fav'] = Variable<bool>(fav);
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      cover: Value(cover),
      fileCover: fileCover == null && nullToAbsent
          ? const Value.absent()
          : Value(fileCover),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      fav: Value(fav),
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      cover: serializer.fromJson<String>(json['cover']),
      fileCover: serializer.fromJson<String?>(json['fileCover']),
      category: serializer.fromJson<int?>(json['category']),
      time: serializer.fromJson<DateTime?>(json['time']),
      fav: serializer.fromJson<bool>(json['fav']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'cover': serializer.toJson<String>(cover),
      'fileCover': serializer.toJson<String?>(fileCover),
      'category': serializer.toJson<int?>(category),
      'time': serializer.toJson<DateTime?>(time),
      'fav': serializer.toJson<bool>(fav),
    };
  }

  Todo copyWith(
          {int? id,
          String? title,
          String? content,
          String? cover,
          String? fileCover,
          int? category,
          DateTime? time,
          bool? fav}) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        cover: cover ?? this.cover,
        fileCover: fileCover ?? this.fileCover,
        category: category ?? this.category,
        time: time ?? this.time,
        fav: fav ?? this.fav,
      );
  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('cover: $cover, ')
          ..write('fileCover: $fileCover, ')
          ..write('category: $category, ')
          ..write('time: $time, ')
          ..write('fav: $fav')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          title.hashCode,
          $mrjc(
              content.hashCode,
              $mrjc(
                  cover.hashCode,
                  $mrjc(
                      fileCover.hashCode,
                      $mrjc(category.hashCode,
                          $mrjc(time.hashCode, fav.hashCode))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.cover == this.cover &&
          other.fileCover == this.fileCover &&
          other.category == this.category &&
          other.time == this.time &&
          other.fav == this.fav);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<String> cover;
  final Value<String?> fileCover;
  final Value<int?> category;
  final Value<DateTime?> time;
  final Value<bool> fav;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.cover = const Value.absent(),
    this.fileCover = const Value.absent(),
    this.category = const Value.absent(),
    this.time = const Value.absent(),
    this.fav = const Value.absent(),
  });
  TodosCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String content,
    required String cover,
    this.fileCover = const Value.absent(),
    this.category = const Value.absent(),
    this.time = const Value.absent(),
    this.fav = const Value.absent(),
  })  : title = Value(title),
        content = Value(content),
        cover = Value(cover);
  static Insertable<Todo> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? cover,
    Expression<String?>? fileCover,
    Expression<int?>? category,
    Expression<DateTime?>? time,
    Expression<bool>? fav,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (cover != null) 'cover': cover,
      if (fileCover != null) 'file_cover': fileCover,
      if (category != null) 'category': category,
      if (time != null) 'time': time,
      if (fav != null) 'fav': fav,
    });
  }

  TodosCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? content,
      Value<String>? cover,
      Value<String?>? fileCover,
      Value<int?>? category,
      Value<DateTime?>? time,
      Value<bool>? fav}) {
    return TodosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      cover: cover ?? this.cover,
      fileCover: fileCover ?? this.fileCover,
      category: category ?? this.category,
      time: time ?? this.time,
      fav: fav ?? this.fav,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (cover.present) {
      map['cover'] = Variable<String>(cover.value);
    }
    if (fileCover.present) {
      map['file_cover'] = Variable<String?>(fileCover.value);
    }
    if (category.present) {
      map['category'] = Variable<int?>(category.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime?>(time.value);
    }
    if (fav.present) {
      map['fav'] = Variable<bool>(fav.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('cover: $cover, ')
          ..write('fileCover: $fileCover, ')
          ..write('category: $category, ')
          ..write('time: $time, ')
          ..write('fav: $fav')
          ..write(')'))
        .toString();
  }
}

class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  final GeneratedDatabase _db;
  final String? _alias;
  $TodosTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _contentMeta = const VerificationMeta('content');
  late final GeneratedColumn<String?> content = GeneratedColumn<String?>(
      'content', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _coverMeta = const VerificationMeta('cover');
  late final GeneratedColumn<String?> cover = GeneratedColumn<String?>(
      'cover', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _fileCoverMeta = const VerificationMeta('fileCover');
  late final GeneratedColumn<String?> fileCover = GeneratedColumn<String?>(
      'file_cover', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _categoryMeta = const VerificationMeta('category');
  late final GeneratedColumn<int?> category = GeneratedColumn<int?>(
      'category', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  late final GeneratedColumn<DateTime?> time = GeneratedColumn<DateTime?>(
      'time', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _favMeta = const VerificationMeta('fav');
  late final GeneratedColumn<bool?> fav = GeneratedColumn<bool?>(
      'fav', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (fav IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, content, cover, fileCover, category, time, fav];
  @override
  String get aliasedName => _alias ?? 'todos';
  @override
  String get actualTableName => 'todos';
  @override
  VerificationContext validateIntegrity(Insertable<Todo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('cover')) {
      context.handle(
          _coverMeta, cover.isAcceptableOrUnknown(data['cover']!, _coverMeta));
    } else if (isInserting) {
      context.missing(_coverMeta);
    }
    if (data.containsKey('file_cover')) {
      context.handle(_fileCoverMeta,
          fileCover.isAcceptableOrUnknown(data['file_cover']!, _fileCoverMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    }
    if (data.containsKey('fav')) {
      context.handle(
          _favMeta, fav.isAcceptableOrUnknown(data['fav']!, _favMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Todo.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(_db, alias);
  }
}

class DateTodo extends DataClass implements Insertable<DateTodo> {
  final int id;
  final String title;
  final String content;
  final String cover;
  final String? fileCover;
  final int? category;
  final DateTime? time;
  final bool fav;
  DateTodo(
      {required this.id,
      required this.title,
      required this.content,
      required this.cover,
      this.fileCover,
      this.category,
      this.time,
      required this.fav});
  factory DateTodo.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return DateTodo(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      content: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}content'])!,
      cover: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cover'])!,
      fileCover: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}file_cover']),
      category: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}category']),
      time: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}time']),
      fav: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fav'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['cover'] = Variable<String>(cover);
    if (!nullToAbsent || fileCover != null) {
      map['file_cover'] = Variable<String?>(fileCover);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<int?>(category);
    }
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<DateTime?>(time);
    }
    map['fav'] = Variable<bool>(fav);
    return map;
  }

  DateTodosCompanion toCompanion(bool nullToAbsent) {
    return DateTodosCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      cover: Value(cover),
      fileCover: fileCover == null && nullToAbsent
          ? const Value.absent()
          : Value(fileCover),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      fav: Value(fav),
    );
  }

  factory DateTodo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DateTodo(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      cover: serializer.fromJson<String>(json['cover']),
      fileCover: serializer.fromJson<String?>(json['fileCover']),
      category: serializer.fromJson<int?>(json['category']),
      time: serializer.fromJson<DateTime?>(json['time']),
      fav: serializer.fromJson<bool>(json['fav']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'cover': serializer.toJson<String>(cover),
      'fileCover': serializer.toJson<String?>(fileCover),
      'category': serializer.toJson<int?>(category),
      'time': serializer.toJson<DateTime?>(time),
      'fav': serializer.toJson<bool>(fav),
    };
  }

  DateTodo copyWith(
          {int? id,
          String? title,
          String? content,
          String? cover,
          String? fileCover,
          int? category,
          DateTime? time,
          bool? fav}) =>
      DateTodo(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        cover: cover ?? this.cover,
        fileCover: fileCover ?? this.fileCover,
        category: category ?? this.category,
        time: time ?? this.time,
        fav: fav ?? this.fav,
      );
  @override
  String toString() {
    return (StringBuffer('DateTodo(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('cover: $cover, ')
          ..write('fileCover: $fileCover, ')
          ..write('category: $category, ')
          ..write('time: $time, ')
          ..write('fav: $fav')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          title.hashCode,
          $mrjc(
              content.hashCode,
              $mrjc(
                  cover.hashCode,
                  $mrjc(
                      fileCover.hashCode,
                      $mrjc(category.hashCode,
                          $mrjc(time.hashCode, fav.hashCode))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DateTodo &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.cover == this.cover &&
          other.fileCover == this.fileCover &&
          other.category == this.category &&
          other.time == this.time &&
          other.fav == this.fav);
}

class DateTodosCompanion extends UpdateCompanion<DateTodo> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<String> cover;
  final Value<String?> fileCover;
  final Value<int?> category;
  final Value<DateTime?> time;
  final Value<bool> fav;
  const DateTodosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.cover = const Value.absent(),
    this.fileCover = const Value.absent(),
    this.category = const Value.absent(),
    this.time = const Value.absent(),
    this.fav = const Value.absent(),
  });
  DateTodosCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String content,
    required String cover,
    this.fileCover = const Value.absent(),
    this.category = const Value.absent(),
    this.time = const Value.absent(),
    this.fav = const Value.absent(),
  })  : title = Value(title),
        content = Value(content),
        cover = Value(cover);
  static Insertable<DateTodo> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? cover,
    Expression<String?>? fileCover,
    Expression<int?>? category,
    Expression<DateTime?>? time,
    Expression<bool>? fav,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (cover != null) 'cover': cover,
      if (fileCover != null) 'file_cover': fileCover,
      if (category != null) 'category': category,
      if (time != null) 'time': time,
      if (fav != null) 'fav': fav,
    });
  }

  DateTodosCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? content,
      Value<String>? cover,
      Value<String?>? fileCover,
      Value<int?>? category,
      Value<DateTime?>? time,
      Value<bool>? fav}) {
    return DateTodosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      cover: cover ?? this.cover,
      fileCover: fileCover ?? this.fileCover,
      category: category ?? this.category,
      time: time ?? this.time,
      fav: fav ?? this.fav,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (cover.present) {
      map['cover'] = Variable<String>(cover.value);
    }
    if (fileCover.present) {
      map['file_cover'] = Variable<String?>(fileCover.value);
    }
    if (category.present) {
      map['category'] = Variable<int?>(category.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime?>(time.value);
    }
    if (fav.present) {
      map['fav'] = Variable<bool>(fav.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DateTodosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('cover: $cover, ')
          ..write('fileCover: $fileCover, ')
          ..write('category: $category, ')
          ..write('time: $time, ')
          ..write('fav: $fav')
          ..write(')'))
        .toString();
  }
}

class $DateTodosTable extends DateTodos
    with TableInfo<$DateTodosTable, DateTodo> {
  final GeneratedDatabase _db;
  final String? _alias;
  $DateTodosTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _contentMeta = const VerificationMeta('content');
  late final GeneratedColumn<String?> content = GeneratedColumn<String?>(
      'content', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _coverMeta = const VerificationMeta('cover');
  late final GeneratedColumn<String?> cover = GeneratedColumn<String?>(
      'cover', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _fileCoverMeta = const VerificationMeta('fileCover');
  late final GeneratedColumn<String?> fileCover = GeneratedColumn<String?>(
      'file_cover', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _categoryMeta = const VerificationMeta('category');
  late final GeneratedColumn<int?> category = GeneratedColumn<int?>(
      'category', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  late final GeneratedColumn<DateTime?> time = GeneratedColumn<DateTime?>(
      'time', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _favMeta = const VerificationMeta('fav');
  late final GeneratedColumn<bool?> fav = GeneratedColumn<bool?>(
      'fav', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (fav IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, content, cover, fileCover, category, time, fav];
  @override
  String get aliasedName => _alias ?? 'date_todos';
  @override
  String get actualTableName => 'date_todos';
  @override
  VerificationContext validateIntegrity(Insertable<DateTodo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('cover')) {
      context.handle(
          _coverMeta, cover.isAcceptableOrUnknown(data['cover']!, _coverMeta));
    } else if (isInserting) {
      context.missing(_coverMeta);
    }
    if (data.containsKey('file_cover')) {
      context.handle(_fileCoverMeta,
          fileCover.isAcceptableOrUnknown(data['file_cover']!, _fileCoverMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    }
    if (data.containsKey('fav')) {
      context.handle(
          _favMeta, fav.isAcceptableOrUnknown(data['fav']!, _favMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DateTodo map(Map<String, dynamic> data, {String? tablePrefix}) {
    return DateTodo.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DateTodosTable createAlias(String alias) {
    return $DateTodosTable(_db, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String description;
  Category({required this.id, required this.description});
  factory Category.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Category(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      description: Value(description),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
    };
  }

  Category copyWith({int? id, String? description}) => Category(
        id: id ?? this.id,
        description: description ?? this.description,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, description.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.description == this.description);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> description;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String description,
  }) : description = Value(description);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
    });
  }

  CategoriesCompanion copyWith({Value<int>? id, Value<String>? description}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  final GeneratedDatabase _db;
  final String? _alias;
  $CategoriesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, description];
  @override
  String get aliasedName => _alias ?? 'categories';
  @override
  String get actualTableName => 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Category.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $TodosTable todos = $TodosTable(this);
  late final $DateTodosTable dateTodos = $DateTodosTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [todos, dateTodos, categories];
}
