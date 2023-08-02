// database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
