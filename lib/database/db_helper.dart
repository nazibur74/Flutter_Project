import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'zstore.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE suppliers(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          company TEXT,
          phone TEXT,
          address TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE products(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          supplier_id INTEGER,
          description TEXT,
          price REAL,
          quantity INTEGER
        )
        ''');

        await db.execute('''
        CREATE TABLE employees(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          dob TEXT,
          phone TEXT,
          email TEXT,
          nid TEXT,
          role TEXT,
          address TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE sales(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          customer_name TEXT,
          phone TEXT,
          date TEXT,
          total_amount REAL
        )
        ''');

        await db.execute('''
        CREATE TABLE sales_items(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sale_id INTEGER,
          product_id INTEGER,
          quantity INTEGER,
          price REAL
        )
        ''');
      },
    );
  }
}
