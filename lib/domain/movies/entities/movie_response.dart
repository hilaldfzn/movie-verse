import 'package:equatable/equatable.dart';
import 'movie.dart';

class MovieResponse extends Equatable {
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  const MovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  bool get hasMorePages => page < totalPages;

  @override
  List<Object?> get props => [page, results, totalPages, totalResults];
}