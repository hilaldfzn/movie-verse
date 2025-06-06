import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../repositories/favorites_repository.dart';

class CheckFavoriteStatus {
  final FavoritesRepository repository;

  CheckFavoriteStatus(this.repository);

  Future<Either<Failure, bool>> call(CheckFavoriteStatusParams params) async {
    return await repository.isFavorite(params.movieId, params.profileId);
  }
}

class CheckFavoriteStatusParams extends Equatable {
  final int movieId;
  final int profileId;

  const CheckFavoriteStatusParams({
    required this.movieId,
    required this.profileId,
  });

  @override
  List<Object?> get props => [movieId, profileId];
}