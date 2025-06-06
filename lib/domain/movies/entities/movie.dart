import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final List<int> genreIds;
  final double popularity;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.genreIds,
    required this.popularity,
  });

  String get posterUrl => posterPath != null 
      ? 'https://image.tmdb.org/t/p/w500$posterPath' 
      : '';

  String get backdropUrl => backdropPath != null 
      ? 'https://image.tmdb.org/t/p/original$backdropPath' 
      : '';

  @override
  List<Object?> get props => [
    id, title, overview, posterPath, backdropPath,
    voteAverage, voteCount, releaseDate, genreIds, popularity
  ];
}