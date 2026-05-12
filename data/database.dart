import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'clothing_store.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT
      )
    ''');
    
    await db.execute('''
      CREATE TABLE products(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        categoryId TEXT NOT NULL,
        description TEXT,
        size TEXT,
        FOREIGN KEY (categoryId) REFERENCES categories(id) ON DELETE CASCADE
      )
    ''');
    
    await db.execute('''
      CREATE TABLE roles(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        permissions TEXT NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE orders(
        id TEXT PRIMARY KEY,
        productId TEXT NOT NULL,
        customerName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        orderDate TEXT NOT NULL,
        status TEXT NOT NULL,
        totalPrice REAL NOT NULL,
        FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE
      )
    ''');
  }
}