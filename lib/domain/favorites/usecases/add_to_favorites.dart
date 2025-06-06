import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../entities/favorite_movie.dart';
import '../repositories/favorites_repository.dart';
import '../../movies/entities/movie.dart';

class AddToFavorites {
  final FavoritesRepository repository;

  AddToFavorites(this.repository);

  Future<Either<Failure, FavoriteMovie>> call(AddToFavoritesParams params) async {
    return await repository.addToFavorites(params.movie, params.profileId);
  }
}

class AddToFavoritesParams extends Equatable {
  final Movie movie;
  final int profileId;

  const AddToFavoritesParams({
    required this.movie,
    required this.profileId,
  });

  @override
  List<Object?> get props => [movie, profileId];
}