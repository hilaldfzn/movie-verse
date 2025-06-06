import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'movie_app.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String profilesTable = 'profiles';
  static const String favoritesTable = 'favorites';

  static Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    // Create profiles table
    await db.execute('''
      CREATE TABLE $profilesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        avatar TEXT,
        userId TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create favorites table
    await db.execute('''
      CREATE TABLE $favoritesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        movieId INTEGER NOT NULL,
        title TEXT NOT NULL,
        posterPath TEXT,
        overview TEXT,
        releaseDate TEXT NOT NULL,
        voteAverage REAL NOT NULL,
        profileId INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (profileId) REFERENCES $profilesTable (id) ON DELETE CASCADE,
        UNIQUE(movieId, profileId)
      )
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_profiles_userId ON $profilesTable(userId)');
    await db.execute('CREATE INDEX idx_favorites_profileId ON $favoritesTable(profileId)');
    await db.execute('CREATE INDEX idx_favorites_movieId ON $favoritesTable(movieId)');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Example: Add new column
      await db.execute('ALTER TABLE profiles ADD COLUMN newColumn TEXT');
    }
  }
}