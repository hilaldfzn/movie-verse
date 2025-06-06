import '../../../core/error/exceptions.dart';
import '../models/favorite_movie_model.dart';
import '../../core/storage/in_memory_storage.dart';
import '../../../domain/favorites/entities/favorite_movie.dart';

abstract class FavoritesLocalDataSource {
  Future<FavoriteMovieModel> addToFavorites(FavoriteMovieModel favorite);
  Future<void> removeFromFavorites(int movieId, int profileId);
  Future<List<FavoriteMovieModel>> getFavorites(int profileId);
  Future<bool> isFavorite(int movieId, int profileId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final InMemoryStorage storage;

  FavoritesLocalDataSourceImpl(this.storage);

  @override
  Future<FavoriteMovieModel> addToFavorites(FavoriteMovieModel favorite) async {
    try {
      print('❤️ Adding to favorites: ${favorite.title}');
      
      final favoriteEntity = FavoriteMovie(
        movieId: favorite.movieId,
        title: favorite.title,
        posterPath: favorite.posterPath,
        overview: favorite.overview,
        releaseDate: favorite.releaseDate,
        voteAverage: favorite.voteAverage,
        profileId: favorite.profileId,
        createdAt: DateTime.now(),
      );
      
      final createdFavorite = await storage.addToFavorites(favoriteEntity);
      
      return FavoriteMovieModel(
        id: createdFavorite.id,
        movieId: createdFavorite.movieId,
        title: createdFavorite.title,
        posterPath: createdFavorite.posterPath,
        overview: createdFavorite.overview,
        releaseDate: createdFavorite.releaseDate,
        voteAverage: createdFavorite.voteAverage,
        profileId: createdFavorite.profileId,
        createdAt: createdFavorite.createdAt,
      );
    } catch (e) {
      print('❌ Failed to add to favorites: $e');
      throw CacheException('Failed to add to favorites: $e');
    }
  }

  @override
  Future<void> removeFromFavorites(int movieId, int profileId) async {
    try {
      print('💔 Removing from favorites: Movie ID $movieId');
      await storage.removeFromFavorites(movieId, profileId);
    } catch (e) {
      print('❌ Failed to remove from favorites: $e');
      throw CacheException('Failed to remove from favorites: $e');
    }
  }

  @override
  Future<List<FavoriteMovieModel>> getFavorites(int profileId) async {
    try {
      print('📋 Getting favorites for profile: $profileId');
      
      final favorites = await storage.getFavorites(profileId);
      
      return favorites.map((favorite) => FavoriteMovieModel(
        id: favorite.id,
        movieId: favorite.movieId,
        title: favorite.title,
        posterPath: favorite.posterPath,
        overview: favorite.overview,
        releaseDate: favorite.releaseDate,
        voteAverage: favorite.voteAverage,
        profileId: favorite.profileId,
        createdAt: favorite.createdAt,
      )).toList();
    } catch (e) {
      print('❌ Failed to get favorites: $e');
      throw CacheException('Failed to get favorites: $e');
    }
  }

  @override
  Future<bool> isFavorite(int movieId, int profileId) async {
    try {
      final result = await storage.isFavorite(movieId, profileId);
      print('❓ Is favorite (Movie ID $movieId): $result');
      return result;
    } catch (e) {
      print('❌ Failed to check favorite status: $e');
      throw CacheException('Failed to check favorite status: $e');
    }
  }
}