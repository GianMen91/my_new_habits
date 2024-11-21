import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import '../models/todo.dart';
import '../models/todo_history.dart';

class DatabaseHelper {
  static const _databaseName = 'todo_database.db';
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY,
        todoText TEXT NOT NULL,
        isDone INTEGER NOT NULL,
        isFavourite INTEGER NOT NULL,
        recordDate TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE todo_history (
        id INTEGER,
        changeDate TEXT NOT NULL
      )
    ''');

    // Insert default habits
    final now = DateTime.now().toIso8601String();
    await db.execute('''
      INSERT INTO todos (todoText, isDone, isFavourite, recordDate) 
      VALUES
        ('Wake up early', 0, 0, '$now'),
        ('Journal before bed', 0, 0, '$now'),
        ('Learning a new skill', 0, 1, '$now'),
        ('Make exercises', 0, 0, '$now'),
        ('Meditate', 0, 0, '$now'),
        ('Create a proper sleep schedule', 0, 1, '$now'),
        ('Make a walk', 0, 1, '$now'),
        ('Read a book', 0, 1, '$now'),
        ('Limit screen time', 0, 1, '$now'),
        ('Drink 2lt water', 0, 1, '$now'),
        ('Limit Caffeine Intake', 0, 0, '$now'),
        ('Practice Positive Self-Talk', 0, 0, '$now'),
        ('Practice Gratitude', 0, 0, '$now'),
        ('Eat healthily', 0, 1, '$now'),
        ('Do Stretching', 0, 0, '$now'),
        ('Dedicate Time to Your Hobby', 0, 1, '$now'),
        ('Practice Yoga', 0, 0, '$now')
    ''');
  }

  // Add a new habit
  Future<void> addNewHabit(String habitText) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.insert('todos', {
      'todoText': habitText,
      'isDone': 0,
      'isFavourite': 0,
      'recordDate': now,
    });
  }

  // Fetch all todos
  Future<List<ToDo>> getTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');

    return List.generate(maps.length, (index) {
      return ToDo.fromMap(maps[index]);
    });
  }

  // Fetch todo history
  Future<List<ToDoHistory>> getToDoHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todo_history');

    return List.generate(maps.length, (index) {
      return ToDoHistory.fromMap(maps[index]);
    });
  }

  // Fetch todo history for a specific date
  Future<List<ToDoHistory>> getToDoHistoryForDate(DateTime date) async {
    final db = await database;
    final String dateStr = date.toIso8601String();
    final String nextDayStr = date.add(Duration(days: 1)).toIso8601String();

    final List<Map<String, dynamic>> maps = await db.query(
      'todo_history',
      where: 'changeDate >= ? AND changeDate < ?',
      whereArgs: [dateStr, nextDayStr],
    );

    return List.generate(maps.length, (index) {
      return ToDoHistory.fromMap(maps[index]);
    });
  }

  // Update the favourite status of a todo
  Future<void> updateFavouriteStatus(ToDo todo) async {
    final db = await database;

    await db.update(
      'todos',
      {'isFavourite': todo.isFavourite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // Update todo status and record history
  Future<void> updateTodoStatus(ToDo todo) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    // Update the todo's status
    await db.update(
      'todos',
      {
        'isDone': todo.isDone ? 1 : 0,
        'recordDate': now,
      },
      where: 'id = ?',
      whereArgs: [todo.id],
    );

    // Insert history if todo is done
    if (todo.isDone) {
      await db.insert('todo_history', {
        'id': todo.id,
        'changeDate': now,
      });
    } else {
      // Remove history records for the same day if undone
      var normalizedNow = now.split('T')[0]; // Date only
      await db.delete(
        'todo_history',
        where: 'id = ? AND DATE(changeDate) = ?',
        whereArgs: [todo.id, normalizedNow],
      );
    }
  }
}
