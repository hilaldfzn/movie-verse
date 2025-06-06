import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../entities/favorite_movie.dart';
import '../../movies/entities/movie.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, FavoriteMovie>> addToFavorites(Movie movie, int profileId);
  Future<Either<Failure, void>> removeFromFavorites(int movieId, int profileId);
  Future<Either<Failure, List<FavoriteMovie>>> getFavorites(int profileId);
  Future<Either<Failure, bool>> isFavorite(int movieId, int profileId);
}