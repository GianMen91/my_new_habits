import 'package:sqflite/sqflite.dart'; // Import for SQLite database operations
import 'package:path/path.dart'; // Import for file path utilities
import 'package:flutter/cupertino.dart'; // Import for Flutter widgets
import '../models/todo.dart'; // Import the Todo model
import '../models/todo_history.dart'; // Import the TodoHistory model

// DatabaseHelper class for managing the SQLite database
class DatabaseHelper {
  // Define the name and version of the database
  static const _databaseName = 'todo_database.db';
  static const _databaseVersion = 1;

  // Private constructor for singleton pattern
  DatabaseHelper._privateConstructor();

  // Singleton instance of DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database; // Cached database instance

  // Getter for the database. If the database is not already initialized, it is created.
  Future<Database> get database async {
    if (_database != null)
      return _database!; // Return existing database if available
    _database = await _initDatabase(); // Initialize the database if not created
    return _database!;
  }

  // Initialize the database by opening it or creating it if it does not exist
  Future<Database> _initDatabase() async {
    WidgetsFlutterBinding
        .ensureInitialized(); // Ensure widget binding is initialized
    String path = join(await getDatabasesPath(),
        _databaseName); // Get the path for the database file
    return await openDatabase(
      path,
      version: _databaseVersion, // Set database version
      onCreate:
          _onCreate, // Specify the function to run on creating the database
    );
  }

  // Function to create the tables when the database is first created
  Future<void> _onCreate(Database db, int version) async {
    // Create 'todos' table with the necessary columns
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY,
        todoText TEXT NOT NULL,
        isDone INTEGER NOT NULL,
        isFavourite INTEGER NOT NULL,
        recordDate TEXT NOT NULL
      )
    ''');

    // Create 'todo_history' table to track changes to todos
    await db.execute('''
      CREATE TABLE todo_history (
        id INTEGER,
        changeDate TEXT NOT NULL
      )
    ''');

    // Insert default habits into the 'todos' table
    final now = DateTime.now().toIso8601String(); // Get current date/time
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

  // Add a new habit to the database
  Future<void> addNewHabit(String habitText) async {
    final db = await database; // Get the database instance
    final now = DateTime.now().toIso8601String(); // Get current date/time

    // Insert new habit into 'todos' table
    await db.insert('todos', {
      'todoText': habitText,
      'isDone': 0, // Default to not done
      'isFavourite': 0, // Default to not favourite
      'recordDate': now, // Record the current date/time
    });
  }

  // Fetch all todos from the database
  Future<List<ToDo>> getTodos() async {
    final db = await database; // Get the database instance
    final List<Map<String, dynamic>> maps =
        await db.query('todos'); // Query the 'todos' table

    // Convert the retrieved rows into a list of ToDo objects
    return List.generate(maps.length, (index) {
      return ToDo.fromMap(maps[index]);
    });
  }

  // Fetch all todo history from the database
  Future<List<ToDoHistory>> getToDoHistory() async {
    final db = await database; // Get the database instance
    final List<Map<String, dynamic>> maps =
        await db.query('todo_history'); // Query the 'todo_history' table

    // Convert the retrieved rows into a list of ToDoHistory objects
    return List.generate(maps.length, (index) {
      return ToDoHistory.fromMap(maps[index]);
    });
  }

  // Fetch todo history for a specific date range (one day)
  Future<List<ToDoHistory>> getToDoHistoryForDate(DateTime date) async {
    final db = await database; // Get the database instance
    final String dateStr = date.toIso8601String(); // Convert date to string
    final String nextDayStr = date
        .add(const Duration(days: 1))
        .toIso8601String(); // Get the next day as a string

    // Query the 'todo_history' table for records within the specified date range
    final List<Map<String, dynamic>> maps = await db.query(
      'todo_history',
      where: 'changeDate >= ? AND changeDate < ?', // Filter by date range
      whereArgs: [dateStr, nextDayStr],
    );

    // Convert the retrieved rows into a list of ToDoHistory objects
    return List.generate(maps.length, (index) {
      return ToDoHistory.fromMap(maps[index]);
    });
  }

  // Update the favourite status of a todo
  Future<void> updateFavouriteStatus(ToDo todo) async {
    final db = await database; // Get the database instance

    // Update the 'isFavourite' status of the specified todo
    await db.update(
      'todos',
      {'isFavourite': todo.isFavourite ? 1 : 0},
      // Set to 1 if true, otherwise 0
      where: 'id = ?',
      whereArgs: [todo.id], // Filter by todo id
    );
  }

  // Update the status of a todo (mark as done/undone) and record the change in history
  Future<void> updateTodoStatus(ToDo todo) async {
    final db = await database; // Get the database instance
    final now = DateTime.now().toIso8601String(); // Get current date/time

    // Update the 'isDone' status and record date for the specified todo
    await db.update(
      'todos',
      {
        'isDone': todo.isDone ? 1 : 0, // Set to 1 if done, otherwise 0
        'recordDate': now, // Record the current date/time
      },
      where: 'id = ?',
      whereArgs: [todo.id], // Filter by todo id
    );

    // Insert a history record if the todo is marked as done
    if (todo.isDone) {
      await db.insert('todo_history', {
        'id': todo.id,
        'changeDate': now, // Record the change date
      });
    } else {
      // Remove history records for the same day if the todo is undone
      var normalizedNow = now.split('T')[0]; // Extract the date only (no time)
      await db.delete(
        'todo_history',
        where: 'id = ? AND DATE(changeDate) = ?',
        whereArgs: [todo.id, normalizedNow], // Filter by todo id and date
      );
    }
  }
}
