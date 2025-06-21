import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/todo.dart'; // Import your Todo model

/// A service class to manage SQLite database operations for To-Do items.
class TodoDbService {
  static Database? _database; // The SQLite database instance
  static const String _tableName = 'todos'; // Table name for To-Do items

  /// Private constructor to prevent direct instantiation (Singleton pattern).
  TodoDbService._privateConstructor();
  static final TodoDbService instance = TodoDbService._privateConstructor();

  /// Gets the database instance, initializing it if it doesn't exist.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  /// Initializes the SQLite database.
  /// It opens the database and creates the 'todos' table if it doesn't exist.
  Future<Database> _initDB() async {
    // Get the default databases location.
    String path = await getDatabasesPath();
    String databasePath = join(path, 'todo_app.db'); // Define database file name

    // Open the database or create it if it doesn't exist
    return await openDatabase(
      databasePath,
      version: 1, // Database version
      onCreate: _onCreate, // Callback for database creation
    );
  }

  /// Callback method to create tables when the database is first created.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        dueDate INTEGER,
        category TEXT,
        isCompleted INTEGER
      )
    ''');
  }

  /// Converts a [Todo] object into a [Map] for database insertion/update.
  /// SQLite does not store DateTime directly, so convert to milliseconds since epoch.
  /// Boolean values are stored as integers (0 or 1).
  Map<String, dynamic> _toMap(Todo todo) {
    return {
      'id': todo.id,
      'title': todo.title,
      'description': todo.description,
      'dueDate': todo.dueDate.millisecondsSinceEpoch, // Store date as integer
      'category': todo.category.name, // Store enum name as string
      'isCompleted': todo.isCompleted ? 1 : 0, // Store boolean as 0 or 1
    };
  }

  /// Converts a [Map] retrieved from the database into a [Todo] object.
  Todo _fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int),
      category: TodoCategory.values.firstWhere(
            (e) => e.name == map['category'],
        orElse: () => TodoCategory.other, // Fallback if category not found
      ),
      isCompleted: (map['isCompleted'] as int) == 1, // Convert integer back to boolean
    );
  }

  /// Inserts a new To-Do item into the database.
  Future<void> insertTodo(Todo todo) async {
    final db = await database;
    await db.insert(
      _tableName,
      _toMap(todo),
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace if ID exists
    );
  }

  /// Retrieves all To-Do items from the database.
  Future<List<Todo>> getTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    // Convert the list of maps into a list of Todo objects.
    return List.generate(maps.length, (i) {
      return _fromMap(maps[i]);
    });
  }

  /// Updates an existing To-Do item in the database.
  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    await db.update(
      _tableName,
      _toMap(todo),
      where: 'id = ?', // Specify which To-Do to update by its ID
      whereArgs: [todo.id],
    );
  }

  /// Deletes a To-Do item from the database by its ID.
  Future<void> deleteTodo(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Closes the database connection. (Optional, typically for app shutdown)
  Future<void> close() async {
    final db = await database;
    if (db.isOpen) {
      db.close();
      _database = null; // Reset the database instance
    }
  }
}
