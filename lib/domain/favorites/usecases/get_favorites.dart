import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../entities/favorite_movie.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  Future<Either<Failure, List<FavoriteMovie>>> call(GetFavoritesParams params) async {
    return await repository.getFavorites(params.profileId);
  }
}

class GetFavoritesParams extends Equatable {
  final int profileId;

  const GetFavoritesParams({required this.profileId});

  @override
  List<Object?> get props => [profileId];
}