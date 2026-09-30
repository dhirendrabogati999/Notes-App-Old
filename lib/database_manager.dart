import 'dart:io';
import 'package:notes/models/todo_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();

  static const String _databaseName = 'notes.db';
  static const int _databaseVersion = 2;

  static const String tableTodo = 'todo';
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnNote = 'note';
  static const String columnTime = 'time';
  static const String columnIsDeleted = 'isDeleted';
  static const String columnIsFavourite = 'isFavourite';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = '${databasesPath}${Platform.pathSeparator}$_databaseName';
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTodo (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnNote TEXT NOT NULL,
        $columnTime TEXT,
        $columnIsDeleted INTEGER NOT NULL DEFAULT 0,
        $columnIsFavourite INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<int> insertTodo(Map<String, dynamic> todo) async {
    final db = await database;
    return await db.insert(tableTodo, todo);
  }

  Future<List<Todo>> fetchTodos({bool? deleted, bool? favourite}) async {
    final db = await database;
    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    if (deleted != null) {
      whereClauses.add('$columnIsDeleted = ?');
      whereArgs.add(deleted ? 1 : 0);
    }
    if (favourite != null) {
      whereClauses.add('$columnIsFavourite = ?');
      whereArgs.add(favourite ? 1 : 0);
    }

    final results = await db.query(
      tableTodo,
      where: whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );
    List<Todo> todos = [];
    for (var result in results) {
      final Todo todo = Todo(
        id: result[columnId] as int? ?? 0,
        title: result[columnTitle] as String? ?? '',
        note: result[columnNote] as String? ?? '',
        time: result[columnTime] as String? ?? '',
        isDeleted: result[columnIsDeleted] == 1,
        isFavourite: result[columnIsFavourite] == 1,
      );
      todos.add(todo);
    }
    return todos;
  }

  Future<int> updateTodo(int id, Map<String, dynamic> values) async {
    final db = await database;
    return await db.update(
      tableTodo,
      values,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete(
      tableTodo,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> markDeleted(int id, bool deleted) async {
    return await updateTodo(id, {columnIsDeleted: deleted ? 1 : 0});
  }

  Future<int> markFavourite(int id, bool favourite) async {
    return await updateTodo(id, {columnIsFavourite: favourite ? 1 : 0});
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
