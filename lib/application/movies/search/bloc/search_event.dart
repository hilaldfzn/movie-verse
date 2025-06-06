part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchMoviesStarted extends SearchEvent {
  final String query;

  const SearchMoviesStarted(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchMoviesLoadMore extends SearchEvent {
  final String query;
  final int page;

  const SearchMoviesLoadMore({
    required this.query,
    required this.page,
  });

  @override
  List<Object?> get props => [query, page];
}

class SearchMoviesCleared extends SearchEvent {}