import 'package:newmehabits2/todo_history.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'todo.dart';
import 'package:flutter/cupertino.dart';

class DatabaseHelper {
  static const _databaseName = 'todo_database.db';
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: onCreate);
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE todos (
      id INTEGER PRIMARY KEY,
      todoText TEXT NOT NULL,
      isDone INTEGER NOT NULL,
      recordDate DATE NOT NULL
    )
  ''');

    await db.execute('''
      CREATE TABLE todo_history (
        id INTEGER,
        changeDate DATE
      )
    ''');


    final now = DateTime.now();
    await db.execute('''
    INSERT INTO todos (id, todoText, isDone, recordDate)
    VALUES
      (1, 'Waking up early', 0, '${now.toIso8601String()}'),
      (2, 'Journaling before bed', 0, '${now.toIso8601String()}'),
      (3, 'Spend 30 minutes learning an online skill', 0, '${now.toIso8601String()}'),
      (4, 'Spend 1 hour a day exercising', 0, '${now.toIso8601String()}'),
      (5, 'Sit in silence for 10 minute', 0, '${now.toIso8601String()}'),
      (6, 'Creating a proper sleep schedule', 0, '${now.toIso8601String()}'),
      (7, 'Take a 30-minute walk in nature', 0, '${now.toIso8601String()}'),
      (8, 'Read 10 pages a day', 0, '${now.toIso8601String()}'),
      (9, 'Limiting screen time', 0, '${now.toIso8601String()}')
  ''');
  }

  Future<List<ToDo>> getTodos() async {
    final db = await database;
    final maps = await db.query('todos');

    return List.generate(maps.length, (index) {
      return ToDo.fromMap(maps[index]);
    });
  }

  Future<List<ToDoHistory>> getToDoHistory() async {
    final db = await database;
    final maps = await db.query('todo_history');

    return List.generate(maps.length, (index) {
      return ToDoHistory.fromMap(maps[index]);
    });
  }

  Future<List<ToDoHistory>> getToDoHistoryForDate(DateTime date) async {
    final db = await database;

    final maps = await db.query(
      'todo_history',
      where: 'changeDate >= ? AND changeDate < ?',
      whereArgs: [date.toIso8601String(), date.add(Duration(days: 1)).toIso8601String()],
    );

    return List.generate(maps.length, (index) {
      return ToDoHistory.fromMap(maps[index]);
    });
  }

  Future<void> updateTodoStatus(ToDo todo) async {
    final db = await database;
    final now = DateTime.now();

    // Update the current status in the main todos table
    await db.update(
      'todos',
      {
        'isDone': todo.isDone ? 1 : 0,
        'recordDate': now.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [todo.id],
    );

    // Insert a new history record
    if(todo.isDone){
      await db.insert(
        'todo_history',
        {
          'id': todo.id,
          'changeDate': now.toIso8601String(),
        },
      );
    }
  }

}
