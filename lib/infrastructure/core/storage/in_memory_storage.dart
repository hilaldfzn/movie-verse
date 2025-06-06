import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/auth/entities/profile.dart';
import '../../../domain/favorites/entities/favorite_movie.dart';

class InMemoryStorage {
  static InMemoryStorage? _instance;
  InMemoryStorage._internal();
  
  factory InMemoryStorage() {
    _instance ??= InMemoryStorage._internal();
    return _instance!;
  }

  // In-memory data storage
  final Map<String, List<Profile>> _profiles = {};
  final Map<int, List<FavoriteMovie>> _favorites = {};
  int _profileIdCounter = 1;
  int _favoriteIdCounter = 1;

  // SharedPreferences for persistence
  SharedPreferences? _prefs;

  Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs;
    await _loadData();
    print('💾 In-memory storage initialized');
  }

  // Profile Operations
  Future<Profile> createProfile(String name, String? avatar, String userId) async {
    final profile = Profile(
      id: _profileIdCounter++,
      name: name,
      avatar: avatar,
      userId: userId,
      createdAt: DateTime.now(),
    );

    if (_profiles[userId] == null) {
      _profiles[userId] = [];
    }
    _profiles[userId]!.add(profile);

    await _saveProfiles();
    print('👤 Profile created: ${profile.name} (ID: ${profile.id})');
    return profile;
  }

  Future<List<Profile>> getProfiles(String userId) async {
    final profiles = _profiles[userId] ?? [];
    print('📋 Found ${profiles.length} profiles for user: $userId');
    return profiles;
  }

  Future<Profile?> getProfileById(int profileId) async {
    for (final profileList in _profiles.values) {
      for (final profile in profileList) {
        if (profile.id == profileId) {
          return profile;
        }
      }
    }
    return null;
  }

  // Favorite Operations
  Future<FavoriteMovie> addToFavorites(FavoriteMovie favorite) async {
    final newFavorite = FavoriteMovie(
      id: _favoriteIdCounter++,
      movieId: favorite.movieId,
      title: favorite.title,
      posterPath: favorite.posterPath,
      overview: favorite.overview,
      releaseDate: favorite.releaseDate,
      voteAverage: favorite.voteAverage,
      profileId: favorite.profileId,
      createdAt: DateTime.now(),
    );

    if (_favorites[favorite.profileId] == null) {
      _favorites[favorite.profileId] = [];
    }

    // Check if already exists
    final exists = _favorites[favorite.profileId]!
        .any((f) => f.movieId == favorite.movieId);
    
    if (!exists) {
      _favorites[favorite.profileId]!.add(newFavorite);
      await _saveFavorites();
      print('❤️ Added to favorites: ${favorite.title}');
    }

    return newFavorite;
  }

  Future<void> removeFromFavorites(int movieId, int profileId) async {
    if (_favorites[profileId] != null) {
      _favorites[profileId]!.removeWhere((f) => f.movieId == movieId);
      await _saveFavorites();
      print('💔 Removed from favorites: Movie ID $movieId');
    }
  }

  Future<List<FavoriteMovie>> getFavorites(int profileId) async {
    final favorites = _favorites[profileId] ?? [];
    print('❤️ Found ${favorites.length} favorites for profile: $profileId');
    return favorites;
  }

  Future<bool> isFavorite(int movieId, int profileId) async {
    if (_favorites[profileId] == null) return false;
    return _favorites[profileId]!.any((f) => f.movieId == movieId);
  }

  // Persistence using SharedPreferences
  Future<void> _saveProfiles() async {
    if (_prefs == null) return;
    
    final Map<String, dynamic> profilesJson = {};
    _profiles.forEach((userId, profiles) {
      profilesJson[userId] = profiles.map((p) => {
        'id': p.id,
        'name': p.name,
        'avatar': p.avatar,
        'userId': p.userId,
        'createdAt': p.createdAt.toIso8601String(),
      }).toList();
    });

    await _prefs!.setString('profiles_data', json.encode(profilesJson));
    print('💾 Profiles saved to SharedPreferences');
  }

  Future<void> _saveFavorites() async {
    if (_prefs == null) return;
    
    final Map<String, dynamic> favoritesJson = {};
    _favorites.forEach((profileId, favorites) {
      favoritesJson[profileId.toString()] = favorites.map((f) => {
        'id': f.id,
        'movieId': f.movieId,
        'title': f.title,
        'posterPath': f.posterPath,
        'overview': f.overview,
        'releaseDate': f.releaseDate,
        'voteAverage': f.voteAverage,
        'profileId': f.profileId,
        'createdAt': f.createdAt.toIso8601String(),
      }).toList();
    });

    await _prefs!.setString('favorites_data', json.encode(favoritesJson));
    print('💾 Favorites saved to SharedPreferences');
  }

  Future<void> _loadData() async {
    if (_prefs == null) return;

    // Load profiles
    final profilesData = _prefs!.getString('profiles_data');
    if (profilesData != null) {
      try {
        final Map<String, dynamic> profilesJson = json.decode(profilesData);
        _profiles.clear();
        
        profilesJson.forEach((userId, profilesList) {
          _profiles[userId] = (profilesList as List).map((p) {
            final profile = Profile(
              id: p['id'],
              name: p['name'],
              avatar: p['avatar'],
              userId: p['userId'],
              createdAt: DateTime.parse(p['createdAt']),
            );
            
            // Update counter
            if (profile.id! >= _profileIdCounter) {
              _profileIdCounter = profile.id! + 1;
            }
            
            return profile;
          }).toList();
        });
        
        print('📥 Loaded ${_profiles.length} profile groups from storage');
      } catch (e) {
        print('❌ Error loading profiles: $e');
      }
    }

    // Load favorites
    final favoritesData = _prefs!.getString('favorites_data');
    if (favoritesData != null) {
      try {
        final Map<String, dynamic> favoritesJson = json.decode(favoritesData);
        _favorites.clear();
        
        favoritesJson.forEach((profileIdStr, favoritesList) {
          final profileId = int.parse(profileIdStr);
          _favorites[profileId] = (favoritesList as List).map((f) {
            final favorite = FavoriteMovie(
              id: f['id'],
              movieId: f['movieId'],
              title: f['title'],
              posterPath: f['posterPath'],
              overview: f['overview'],
              releaseDate: f['releaseDate'],
              voteAverage: f['voteAverage'].toDouble(),
              profileId: f['profileId'],
              createdAt: DateTime.parse(f['createdAt']),
            );
            
            // Update counter
            if (favorite.id! >= _favoriteIdCounter) {
              _favoriteIdCounter = favorite.id! + 1;
            }
            
            return favorite;
          }).toList();
        });
        
        print('📥 Loaded ${_favorites.length} favorite groups from storage');
      } catch (e) {
        print('❌ Error loading favorites: $e');
      }
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    _profiles.clear();
    _favorites.clear();
    _profileIdCounter = 1;
    _favoriteIdCounter = 1;
    
    if (_prefs != null) {
      await _prefs!.remove('profiles_data');
      await _prefs!.remove('favorites_data');
    }
    
    print('🧹 All data cleared');
  }

  // Debug info
  void printDebugInfo() {
    print('🔍 Debug Info:');
    print('  - Profiles: ${_profiles.length} users');
    print('  - Favorites: ${_favorites.length} profiles');
    print('  - Next Profile ID: $_profileIdCounter');
    print('  - Next Favorite ID: $_favoriteIdCounter');
  }
}