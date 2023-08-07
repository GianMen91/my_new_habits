// database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model/todo.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


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

    return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: onCreate);
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE todos (
      id INTEGER PRIMARY KEY,
      todoText TEXT NOT NULL,
      isDone INTEGER NOT NULL
    )
  ''');
    await db.execute('''
    INSERT INTO todos (id, todoText, isDone)
    VALUES
      (1, 'Waking up early', 0),
      (2, 'Journaling before bed', 0),
      (3, 'Learning an online skill', 0),
      (4, 'Exercising', 0),
      (5, 'Creating a proper sleep schedule', 0),
      (6, 'Taking a 30-minute walk in nature', 0),
      (7, 'Reading 10 pages a day', 0),
      (8, 'Limiting screen time', 0)
  ''');
  }


  Future<List<ToDo>> getTodos() async {
    final db = await database;
    final maps = await db.query('todos');

    return List.generate(maps.length, (index) {
      return ToDo.fromMap(maps[index]);
    });
  }

  Future<void> insertTodo(ToDo todo) async {
    final db = await database;
    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTodoStatus(ToDo todo) async {
    final db = await database;
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodoById(int id) async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
