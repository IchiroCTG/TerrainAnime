
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:terrain_anime/entities/comment.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('comments.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE comments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      text TEXT NOT NULL,
      author TEXT NOT NULL,
      date TEXT NOT NULL
    )
    ''');
  }

  Future<int> createComment(Comment comment) async {
    final db = await database;
    return await db.insert('comments', comment.toMap());
  }

  Future<int> updateComment(Comment comment) async {
    final db = await database;
    return await db.update(
      'comments',
      comment.toMap(),
      where: 'id = ?',
      whereArgs: [comment.id],
    );
  }

  Future<int> deleteComment(int id) async {
    final db = await database;
    return await db.delete(
      'comments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Comment>> getComments() async {
    final db = await database;
    final result = await db.query('comments');
    return result.map((map) => Comment.fromMap(map)).toList();
  }
}