import 'package:newmehabits2/models/todo_history.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:flutter/cupertino.dart';

import '../models/todo.dart';

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
      isFavourite INTEGER NOT NULL,
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
    INSERT INTO todos (id, todoText, isDone, isFavourite, recordDate)
    VALUES
      (1, 'Wake up early', 0, 0,'${now.toIso8601String()}'),
      (2, 'Journal before bed', 0, 0,'${now.toIso8601String()}'),
      (3, 'Learning a new skill', 0, 1,'${now.toIso8601String()}'),
      (4, 'Make exercises', 0, 0,'${now.toIso8601String()}'),
      (5, 'Meditate', 0, 0,'${now.toIso8601String()}'),
      (6, 'Create a proper sleep schedule', 0, 1,'${now.toIso8601String()}'),
      (7, 'Make a walk', 0, 1,'${now.toIso8601String()}'),
      (8, 'Read a book', 0, 1,'${now.toIso8601String()}'),
      (9, 'Limit screen time', 0, 1,'${now.toIso8601String()}'),
      (10, 'Drink 2lt water', 0, 1,'${now.toIso8601String()}'),
      (11, 'Limit Caffeine Intake', 0, 0,'${now.toIso8601String()}'),
      (12, 'Practice Positive Self-Talk', 0, 0,'${now.toIso8601String()}'),
      (13, 'Practice Gratitude', 0, 0,'${now.toIso8601String()}'),
      (14, 'Eat healthily', 0, 1,'${now.toIso8601String()}'),
      (15, 'Do Stretching', 0, 0,'${now.toIso8601String()}'),
      (16, 'Dedicate Time to Your Hobby', 0, 1,'${now.toIso8601String()}'),
      (17, 'Practice Yoga', 0, 0,'${now.toIso8601String()}')
  ''');
  }

  Future<void> addNewHabit(String habitText) async {
    final db = await database;
    final now = DateTime.now();

    // Insert a new row into the 'todos' table
    await db.insert(
      'todos',
      {
        'todoText': habitText,
        'isDone': 0,
        'isFavourite': 0,
        'recordDate': now.toIso8601String(),
      },
    );
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
      whereArgs: [
        date.toIso8601String(),
        date.add(const Duration(days: 1)).toIso8601String()
      ],
    );

    return List.generate(maps.length, (index) {
      return ToDoHistory.fromMap(maps[index]);
    });
  }

  Future<void> updateFavouriteStatus(ToDo todo) async {
    final db = await database;

    // Update the current status in the main todos table
    await db.update(
      'todos',
      {
        'isFavourite': todo.isFavourite ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [todo.id],
    );
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
    if (todo.isDone) {
      await db.insert(
        'todo_history',
        {
          'id': todo.id,
          'changeDate': now.toIso8601String(),
        },
      );
    } else {
      // Delete history records for the same day (ignoring time)
      var normalizedNow =
          now.toIso8601String().split('T')[0]; // Extract the date portion
      await db.delete(
        'todo_history',
        where: 'id = ? AND DATE(changeDate) = ?',
        whereArgs: [todo.id, normalizedNow],
      );
    }
  }
}
