// database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'ReadingProgressScreen.dart';

class DatabaseHelper {
  static const String tableName = 'nature_walks';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnDuration = 'duration';
  static const String columnStartTime = 'start_time';
  static const String columnEndTime = 'end_time';

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'nature_walks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $tableName (
          $columnId INTEGER PRIMARY KEY,
          $columnName TEXT NOT NULL,
          $columnDuration INTEGER NOT NULL,
          $columnStartTime TEXT NOT NULL,
          $columnEndTime TEXT NOT NULL
        )
      ''');

        await db.execute('''
        CREATE TABLE books (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          author TEXT NOT NULL,
          current_page INTEGER NOT NULL,
          total_pages INTEGER NOT NULL
        )
      ''');

        await db.execute('''
        CREATE TABLE journal_entries (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          timestamp TEXT NOT NULL
        )
      ''');

        await db.execute('''
        CREATE TABLE exercise_activities (
          id INTEGER PRIMARY KEY,
          activity_type TEXT NOT NULL,
          duration INTEGER NOT NULL,
          timestamp TEXT NOT NULL
        )
      ''');

        await db.execute('''
        CREATE TABLE habits (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          is_completed INTEGER DEFAULT 0
        )
      ''');

        // Create other tables as needed

      },
    );
  }


  Future<void> insertNatureWalk(NatureWalk natureWalk) async {
    final db = await initDatabase();
    await db.insert(
      tableName,
      natureWalk.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NatureWalk>> getNatureWalks() async {
    final db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return NatureWalk.fromMap(maps[i]);
    });
  }

  Future<List<Book>> getBooks() async {
    final db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future<void> insertBook(Book book) async {
    final db = await initDatabase();
    await db.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<JournalEntry>> getJournalEntries() async {
    final db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('journal_entries');
    return List.generate(maps.length, (i) {
      return JournalEntry.fromMap(maps[i]);
    });
  }

  Future<void> insertJournalEntry(JournalEntry journalEntry) async {
    final db = await initDatabase();
    await db.insert(
      'journal_entries',
      journalEntry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ExerciseActivity>> getExerciseActivities() async {
    final db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('exercise_activities');
    return List.generate(maps.length, (i) {
      return ExerciseActivity.fromMap(maps[i]);
    });
  }

  Future<void> insertExerciseActivity(ExerciseActivity exerciseActivity) async {
    final db = await initDatabase();
    await db.insert(
      'exercise_activities',
      exerciseActivity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Habit>> getHabits() async {
    final db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i) {
      return Habit.fromMap(maps[i]);
    });
  }

  Future<void> updateHabitCompletionStatus(int habitId, bool isCompleted) async {
    final db = await initDatabase();
    await db.update(
      'habits',
      {'is_completed': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [habitId],
    );
  }
}

class NatureWalk {
  int? id;
  String name;
  int duration;
  String startTime;
  String endTime;

  NatureWalk({
    this.id,
    required this.name,
    required this.duration,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'start_time': startTime,
      'end_time': endTime,
    };
  }

  static NatureWalk fromMap(Map<String, dynamic> map) {
    return NatureWalk(
      id: map['id'],
      name: map['name'],
      duration: map['duration'],
      startTime: map['start_time'],
      endTime: map['end_time'],
    );
  }
}

class Book {
  int? id;
  String title;
  String author;
  int currentPage;
  int totalPages;

  Book({this.id, required this.title, required this.author, required this.currentPage, required this.totalPages});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'current_page': currentPage,
      'total_pages': totalPages,
    };
  }

  static Book fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      currentPage: map['current_page'],
      totalPages: map['total_pages'],
    );
  }
}

class JournalEntry {
  int? id;
  String title;
  String content;
  String timestamp;

  JournalEntry({this.id, required this.title, required this.content, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'timestamp': timestamp,
    };
  }

  static JournalEntry fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      timestamp: map['timestamp'],
    );
  }
}

class ExerciseActivity {
  int? id;
  String activityType;
  int duration;
  String timestamp;

  ExerciseActivity({this.id, required this.activityType, required this.duration, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activity_type': activityType,
      'duration': duration,
      'timestamp': timestamp,
    };
  }

  static ExerciseActivity fromMap(Map<String, dynamic> map) {
    return ExerciseActivity(
      id: map['id'],
      activityType: map['activity_type'],
      duration: map['duration'],
      timestamp: map['timestamp'],
    );
  }
}

class Habit {
  int? id;
  String name;
  bool isCompleted;

  Habit({this.id, required this.name, this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  static Habit fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      isCompleted: map['is_completed'] == 1,
    );
  }
}

