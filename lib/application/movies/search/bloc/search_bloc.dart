import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/movies/entities/movie.dart';
import '../../../../domain/movies/usecases/search_movies.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;

  SearchBloc({required this.searchMovies}) : super(SearchInitial()) {
    on<SearchMoviesStarted>(_onSearchMoviesStarted);
    on<SearchMoviesLoadMore>(_onSearchMoviesLoadMore);
    on<SearchMoviesCleared>(_onSearchMoviesCleared);
  }

  Future<void> _onSearchMoviesStarted(
    SearchMoviesStarted event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final result = await searchMovies(SearchMoviesParams(
      query: event.query,
      page: 1,
    ));

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (movies) {
        if (movies.isEmpty) {
          emit(SearchEmpty(event.query));
        } else {
          emit(SearchLoaded(
            movies: movies,
            query: event.query,
            currentPage: 1,
            hasReachedMax: movies.length < 20,
          ));
        }
      },
    );
  }

  Future<void> _onSearchMoviesLoadMore(
    SearchMoviesLoadMore event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is SearchLoaded && !currentState.hasReachedMax) {
      final result = await searchMovies(SearchMoviesParams(
        query: event.query,
        page: event.page,
      ));

      result.fold(
        (failure) => emit(SearchError(failure.message)),
        (movies) {
          emit(currentState.copyWith(
            movies: List.of(currentState.movies)..addAll(movies),
            currentPage: event.page,
            hasReachedMax: movies.length < 20,
          ));
        },
      );
    }
  }

  void _onSearchMoviesCleared(
    SearchMoviesCleared event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchInitial());
  }
}