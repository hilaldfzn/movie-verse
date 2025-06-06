import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetails {
  final MovieRepository repository;

  GetMovieDetails(this.repository);

  Future<Either<Failure, Movie>> call(GetMovieDetailsParams params) async {
    return await repository.getMovieDetails(params.movieId);
  }
}

class GetMovieDetailsParams extends Equatable {
  final int movieId;

  const GetMovieDetailsParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}