 import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:newsfact/dataStore/database_classes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> getDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();

    return openDatabase(
      join(await getDatabasesPath(), 'newsfact.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE feeds(id INTEGER PRIMARY KEY, type TEXT, url TEXT, name TEXT, image TEXT)',
        );
      },
      version: 1,
    );
  }
}

class FeedsHelper {
    static Future<void> insertFeed(Feed feed) async {
    final db = await DatabaseHelper.getDatabase();

    await db.insert(
      'feeds',
      feed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteFeed(int id) async {
    // Get a reference to the database.
    final db = await DatabaseHelper.getDatabase();

    await db.delete(
      'feeds',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Feed>> feeds() async {
    final db = await DatabaseHelper.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('feeds');

    return List.generate(maps.length, (i) {
      return Feed(
        id: maps[i]['id'] as int,
        url: maps[i]['url'].toString(),
        name: maps[i]['name'].toString(),
        image: maps[i]['image'].toString(),
      );
    });
  }
}