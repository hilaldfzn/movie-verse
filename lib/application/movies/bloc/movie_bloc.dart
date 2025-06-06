import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/movies/entities/movie.dart';
import '../../../domain/movies/usecases/get_popular_movies.dart';
import '../../../domain/movies/usecases/search_movies.dart';
import '../../../domain/movies/usecases/get_movie_details.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetPopularMovies getPopularMovies;
  final SearchMovies searchMovies;
  final GetMovieDetails getMovieDetails;

  MovieBloc({
    required this.getPopularMovies,
    required this.searchMovies,
    required this.getMovieDetails,
  }) : super(MovieInitial()) {
    on<GetPopularMoviesEvent>(_onGetPopularMovies);
    on<GetTopRatedMoviesEvent>(_onGetTopRatedMovies);
    on<GetUpcomingMoviesEvent>(_onGetUpcomingMovies);
    on<SearchMoviesEvent>(_onSearchMovies);
    on<GetMovieDetailsEvent>(_onGetMovieDetails);
  }

  Future<void> _onGetPopularMovies(
    GetPopularMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());
    
    final result = await getPopularMovies(GetPopularMoviesParams(page: event.page));
    
    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movies) => emit(MovieLoaded(
        movies: movies,
        page: event.page,
        hasReachedMax: movies.length < 20,
      )),
    );
  }

  Future<void> _onGetTopRatedMovies(
    GetTopRatedMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());
    
    final result = await getPopularMovies(GetPopularMoviesParams(page: event.page));
    
    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movies) => emit(MovieLoaded(
        movies: movies,
        page: event.page,
        hasReachedMax: movies.length < 20,
      )),
    );
  }

  Future<void> _onGetUpcomingMovies(
    GetUpcomingMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());
    
    final result = await getPopularMovies(GetPopularMoviesParams(page: event.page));
    
    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movies) => emit(MovieLoaded(
        movies: movies,
        page: event.page,
        hasReachedMax: movies.length < 20,
      )),
    );
  }

  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());
    
    final result = await searchMovies(SearchMoviesParams(
      query: event.query,
      page: event.page,
    ));
    
    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movies) => emit(MovieLoaded(
        movies: movies,
        page: event.page,
        hasReachedMax: movies.length < 20,
      )),
    );
  }

  Future<void> _onGetMovieDetails(
    GetMovieDetailsEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());
    
    final result = await getMovieDetails(GetMovieDetailsParams(movieId: event.movieId));
    
    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movie) => emit(MovieDetailsLoaded(movie)),
    );
  }
}