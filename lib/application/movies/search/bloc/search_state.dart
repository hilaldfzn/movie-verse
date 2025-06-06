part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Movie> movies;
  final String query;
  final int currentPage;
  final bool hasReachedMax;

  const SearchLoaded({
    required this.movies,
    required this.query,
    required this.currentPage,
    required this.hasReachedMax,
  });

  SearchLoaded copyWith({
    List<Movie>? movies,
    String? query,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return SearchLoaded(
      movies: movies ?? this.movies,
      query: query ?? this.query,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [movies, query, currentPage, hasReachedMax];
}

class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}