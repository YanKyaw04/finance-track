import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'budgetbuddy.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        avatar TEXT,
        currency TEXT,
        theme TEXT,
        created_at TEXT
      )
    ''');

    // Categories table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon INTEGER,
        isIncome INTEGER NOT NULL
      )
    ''');

    // Transactions table
    await db.execute('''
    CREATE TABLE transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    amount REAL NOT NULL,
    date TEXT NOT NULL,
    categoryId INTEGER NOT NULL,
    note TEXT,
    isIncome INTEGER NOT NULL DEFAULT 0, -- 0 = Expense, 1 = Income
    FOREIGN KEY(categoryId) REFERENCES categories(id) ON DELETE CASCADE
    )
    ''');

    // Budget table
    await db.execute('''
      CREATE TABLE budget(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        amount REAL,
        month INTEGER,
        year INTEGER,
        created_at TEXT,
        FOREIGN KEY(category_id) REFERENCES categories(id)
      )
    ''');

    // Settings table
    await db.execute('''
      CREATE TABLE settings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT,
        value TEXT
      )
    ''');
  }
}
