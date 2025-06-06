import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> call(GetPopularMoviesParams params) async {
    return await repository.getPopularMovies(page: params.page);
  }
}

class GetPopularMoviesParams extends Equatable {
  final int page;

  const GetPopularMoviesParams({required this.page});

  @override
  List<Object> get props => [page];
}