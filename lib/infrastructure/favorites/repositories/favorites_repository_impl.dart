import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/favorites/entities/favorite_movie.dart';
import '../../../domain/favorites/repositories/favorites_repository.dart';
import '../../../domain/movies/entities/movie.dart';
import '../datasources/favorites_local_datasource.dart';
import '../models/favorite_movie_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, FavoriteMovie>> addToFavorites(Movie movie, int profileId) async {
    try {
      final favoriteModel = FavoriteMovieModel(
        movieId: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        overview: movie.overview,
        releaseDate: movie.releaseDate,
        voteAverage: movie.voteAverage,
        profileId: profileId,
        createdAt: DateTime.now(),
      );

      final result = await localDataSource.addToFavorites(favoriteModel);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(int movieId, int profileId) async {
    try {
      await localDataSource.removeFromFavorites(movieId, profileId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<FavoriteMovie>>> getFavorites(int profileId) async {
    try {
      final favorites = await localDataSource.getFavorites(profileId);
      return Right(favorites);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int movieId, int profileId) async {
    try {
      final isFavorite = await localDataSource.isFavorite(movieId, profileId);
      return Right(isFavorite);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}