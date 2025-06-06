import 'package:sqflite/sqflite.dart';
import '../../../core/error/exceptions.dart';
import '../models/favorite_movie_model.dart';
import '../../core/database/app_database.dart';

abstract class FavoritesLocalDataSource {
  Future<FavoriteMovieModel> addToFavorites(FavoriteMovieModel favorite);
  Future<void> removeFromFavorites(int movieId, int profileId);
  Future<List<FavoriteMovieModel>> getFavorites(int profileId);
  Future<bool> isFavorite(int movieId, int profileId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final AppDatabase database;

  FavoritesLocalDataSourceImpl(this.database);

  @override
  Future<FavoriteMovieModel> addToFavorites(FavoriteMovieModel favorite) async {
    try {
      final id = await database.insert('favorites', favorite.toJson()..remove('id'));
      
      return FavoriteMovieModel(
        id: id,
        movieId: favorite.movieId,
        title: favorite.title,
        posterPath: favorite.posterPath,
        overview: favorite.overview,
        releaseDate: favorite.releaseDate,
        voteAverage: favorite.voteAverage,
        profileId: favorite.profileId,
        createdAt: favorite.createdAt,
      );
    } catch (e) {
      throw CacheException('Failed to add to favorites: $e');
    }
  }

  @override
  Future<void> removeFromFavorites(int movieId, int profileId) async {
    try {
      await database.delete(
        'favorites',
        where: 'movieId = ? AND profileId = ?',
        whereArgs: [movieId, profileId],
      );
    } catch (e) {
      throw CacheException('Failed to remove from favorites: $e');
    }
  }

  @override
  Future<List<FavoriteMovieModel>> getFavorites(int profileId) async {
    try {
      final maps = await database.query(
        'favorites',
        where: 'profileId = ?',
        whereArgs: [profileId],
        orderBy: 'createdAt DESC',
      );

      return maps.map((map) => FavoriteMovieModel.fromJson(map)).toList();
    } catch (e) {
      throw CacheException('Failed to get favorites: $e');
    }
  }

  @override
  Future<bool> isFavorite(int movieId, int profileId) async {
    try {
      final maps = await database.query(
        'favorites',
        where: 'movieId = ? AND profileId = ?',
        whereArgs: [movieId, profileId],
        limit: 1,
      );

      return maps.isNotEmpty;
    } catch (e) {
      throw CacheException('Failed to check favorite status: $e');
    }
  }
}