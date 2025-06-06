part of 'movie_bloc.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final int? page;
  final bool hasReachedMax;

  const MovieLoaded({
    required this.movies,
    this.page,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [movies, page, hasReachedMax];
}

class MovieDetailsLoaded extends MovieState {
  final Movie movie;

  const MovieDetailsLoaded(this.movie);

  @override
  List<Object?> get props => [movie];
}

class MovieError extends MovieState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object?> get props => [message];
}