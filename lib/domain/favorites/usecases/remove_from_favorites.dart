import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../repositories/favorites_repository.dart';

class RemoveFromFavorites {
  final FavoritesRepository repository;

  RemoveFromFavorites(this.repository);

  Future<Either<Failure, void>> call(RemoveFromFavoritesParams params) async {
    return await repository.removeFromFavorites(params.movieId, params.profileId);
  }
}

class RemoveFromFavoritesParams extends Equatable {
  final int movieId;
  final int profileId;

  const RemoveFromFavoritesParams({
    required this.movieId,
    required this.profileId,
  });

  @override
  List<Object?> get props => [movieId, profileId];
}