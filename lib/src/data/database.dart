import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

class BmwDatabase {
  final Database _sqlite;

  BmwDatabase(String filePath) : _sqlite = sqlite3.open(filePath) {
    _sqlite.execute('PRAGMA foreign_keys = ON;');
    _createTables();
  }

  factory BmwDatabase.inApp() {
    final filePath = p.join(Directory.current.path, 'bmw.db');
    return BmwDatabase(filePath);
  }

  Database get sqlite => _sqlite;

  void _createTables() {
    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS clients (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT NOT NULL
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS cars (
        id TEXT PRIMARY KEY,
        model TEXT NOT NULL,
        price REAL NOT NULL,
        year INTEGER NOT NULL
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS managers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT NOT NULL
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS test_drives (
        id TEXT PRIMARY KEY,
        clientId TEXT NOT NULL,
        carId TEXT NOT NULL,
        managerId TEXT NOT NULL,
        time TEXT NOT NULL,
        FOREIGN KEY (clientId) REFERENCES clients(id) ON DELETE CASCADE,
        FOREIGN KEY (carId) REFERENCES cars(id) ON DELETE CASCADE,
        FOREIGN KEY (managerId) REFERENCES managers(id) ON DELETE CASCADE
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS orders (
        id TEXT PRIMARY KEY,
        clientId TEXT NOT NULL,
        carId TEXT NOT NULL,
        managerId TEXT NOT NULL,
        totalPrice REAL NOT NULL,
        FOREIGN KEY (clientId) REFERENCES clients(id) ON DELETE CASCADE,
        FOREIGN KEY (carId) REFERENCES cars(id) ON DELETE CASCADE,
        FOREIGN KEY (managerId) REFERENCES managers(id) ON DELETE CASCADE
      );
    ''');
  }

  void close() {
    _sqlite.dispose();
  }
}
