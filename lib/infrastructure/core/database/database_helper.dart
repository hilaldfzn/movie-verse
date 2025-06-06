import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'movie_app.db';
  static const int _databaseVersion = 1;

  // Tables
  static const String profilesTable = 'profiles';
  static const String favoritesTable = 'favorites';

  static Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createTables,
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    // Profiles table
    await db.execute('''
      CREATE TABLE $profilesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        avatar TEXT,
        userId TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Favorites table
    await db.execute('''
      CREATE TABLE $favoritesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        movieId INTEGER NOT NULL,
        title TEXT NOT NULL,
        posterPath TEXT,
        overview TEXT,
        releaseDate TEXT,
        voteAverage REAL,
        profileId INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (profileId) REFERENCES $profilesTable (id)
      )
    ''');
  }
}