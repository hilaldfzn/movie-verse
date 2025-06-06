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
    if (_database != null) return _database!;
    
    try {
      _database = await _initDatabase();
      return _database!;
    } catch (e) {
      print('❌ Error getting database: $e');
      rethrow;
    }
  }

  Future<Database> _initDatabase() async {
    try {
      print('🔧 Initializing database...');
      
      // Get the database path
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, _databaseName);
      
      print('📍 Database path: $path');

      // Open the database
      final database = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
      
      print('✅ Database initialized successfully');
      return database;
    } catch (e) {
      print('❌ Failed to initialize database: $e');
      throw CacheException('Failed to initialize database: $e');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      print('🏗️ Creating database tables...');
      
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
      
      print('✅ Database tables created successfully');
    } catch (e) {
      print('❌ Failed to create database tables: $e');
      throw CacheException('Failed to create database tables: $e');
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('📈 Upgrading database from version $oldVersion to $newVersion');
    
    if (oldVersion < 2) {
      // Example migration
      await db.execute('ALTER TABLE profiles ADD COLUMN newColumn TEXT');
    }
  }

  // CRUD Operations
  Future<int> insert(String table, Map<String, dynamic> values) async {
    try {
      final db = await database;
      print('➕ Inserting into $table: $values');
      final result = await db.insert(table, values);
      print('✅ Insert successful, ID: $result');
      return result;
    } catch (e) {
      print('❌ Failed to insert into $table: $e');
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
      print('🔍 Querying $table with where: $where, args: $whereArgs');
      final result = await db.query(
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
      print('✅ Query successful, found ${result.length} rows');
      return result;
    } catch (e) {
      print('❌ Failed to query $table: $e');
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
      print('📝 Updating $table: $values where $where');
      final result = await db.update(table, values, where: where, whereArgs: whereArgs);
      print('✅ Update successful, affected rows: $result');
      return result;
    } catch (e) {
      print('❌ Failed to update $table: $e');
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
      print('🗑️ Deleting from $table where $where');
      final result = await db.delete(table, where: where, whereArgs: whereArgs);
      print('✅ Delete successful, affected rows: $result');
      return result;
    } catch (e) {
      print('❌ Failed to delete from $table: $e');
      throw CacheException('Failed to delete from $table: $e');
    }
  }

  // Utility methods
  Future<bool> testConnection() async {
    try {
      final db = await database;
      await db.rawQuery('SELECT 1');
      print('✅ Database connection test successful');
      return true;
    } catch (e) {
      print('❌ Database connection test failed: $e');
      return false;
    }
  }

  Future<void> clearAllData() async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete('favorites');
        await txn.delete('profiles');
      });
      print('🧹 All data cleared successfully');
    } catch (e) {
      print('❌ Failed to clear all data: $e');
      throw CacheException('Failed to clear all data: $e');
    }
  }

  Future<Map<String, dynamic>> getDatabaseInfo() async {
    try {
      final db = await database;
      final version = await db.getVersion();
      final path = db.path;
      
      final info = {
        'version': version,
        'path': path,
        'name': _databaseName,
        'isOpen': db.isOpen,
      };
      
      print('ℹ️ Database info: $info');
      return info;
    } catch (e) {
      print('❌ Failed to get database info: $e');
      throw CacheException('Failed to get database info: $e');
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
      print('🔒 Database closed');
    }
  }
}