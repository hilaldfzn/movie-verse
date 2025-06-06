import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> call(SearchMoviesParams params) async {
    return await repository.searchMovies(params.query, page: params.page);
  }
}

class SearchMoviesParams extends Equatable {
  final String query;
  final int page;

  const SearchMoviesParams({
    required this.query,
    required this.page,
  });

  @override
  List<Object> get props => [query, page];
}