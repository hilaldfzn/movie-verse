import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../core/error/exceptions.dart';

class AppDatabase {
  static Database? _database;
  static const String _databaseName = 'movie_app.db';
  static const int _databaseVersion = 1;

  // Singleton pattern
  static AppDatabase? _instance;
  AppDatabase._internal();
  
  factory AppDatabase() {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create profiles table
    await db.execute('''
      CREATE TABLE profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        avatar TEXT,
        userId TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create favorites table
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        movieId INTEGER NOT NULL,
        title TEXT NOT NULL,
        posterPath TEXT,
        overview TEXT,
        releaseDate TEXT NOT NULL,
        voteAverage REAL NOT NULL,
        profileId INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (profileId) REFERENCES profiles (id) ON DELETE CASCADE,
        UNIQUE(movieId, profileId)
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_profiles_userId ON profiles(userId)');
    await db.execute('CREATE INDEX idx_favorites_profileId ON favorites(profileId)');
    await db.execute('CREATE INDEX idx_favorites_movieId ON favorites(movieId)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema upgrades here
    if (oldVersion < 2) {
      // Example: Add new column
      // await db.execute('ALTER TABLE profiles ADD COLUMN newColumn TEXT');
    }
  }

  // Helper methods for database operations
  Future<int> insert(String table, Map<String, dynamic> values) async {
    try {
      final db = await database;
      return await db.insert(table, values);
    } catch (e) {
      throw CacheException('Failed to insert into $table: $e');
    }
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    try {
      final db = await database;
      return await db.query(
        table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      throw CacheException('Failed to query $table: $e');
    }
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final db = await database;
      return await db.update(table, values, where: where, whereArgs: whereArgs);
    } catch (e) {
      throw CacheException('Failed to update $table: $e');
    }
  }

  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final db = await database;
      return await db.delete(table, where: where, whereArgs: whereArgs);
    } catch (e) {
      throw CacheException('Failed to delete from $table: $e');
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  // Batch operations for better performance
  Future<void> batch(Function(Batch) operations) async {
    try {
      final db = await database;
      final batch = db.batch();
      operations(batch);
      await batch.commit(noResult: true);
    } catch (e) {
      throw CacheException('Failed to execute batch operation: $e');
    }
  }

  // Transaction support
  Future<T> transaction<T>(Future<T> Function(Transaction) action) async {
    try {
      final db = await database;
      return await db.transaction(action);
    } catch (e) {
      throw CacheException('Failed to execute transaction: $e');
    }
  }

  // Clear all data (useful for logout)
  Future<void> clearAllData() async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete('favorites');
        await txn.delete('profiles');
      });
    } catch (e) {
      throw CacheException('Failed to clear all data: $e');
    }
  }

  // Get database info
  Future<Map<String, dynamic>> getDatabaseInfo() async {
    final db = await database;
    final version = await db.getVersion();
    final path = db.path;
    
    return {
      'version': version,
      'path': path,
      'name': _databaseName,
    };
  }
}