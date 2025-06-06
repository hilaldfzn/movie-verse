part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class GetPopularMoviesEvent extends MovieEvent {
  final int page;

  const GetPopularMoviesEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class GetTopRatedMoviesEvent extends MovieEvent {
  final int page;

  const GetTopRatedMoviesEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class GetUpcomingMoviesEvent extends MovieEvent {
  final int page;

  const GetUpcomingMoviesEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class SearchMoviesEvent extends MovieEvent {
  final String query;
  final int page;

  const SearchMoviesEvent({
    required this.query,
    this.page = 1,
  });

  @override
  List<Object?> get props => [query, page];
}

class GetMovieDetailsEvent extends MovieEvent {
  final int movieId;

  const GetMovieDetailsEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}