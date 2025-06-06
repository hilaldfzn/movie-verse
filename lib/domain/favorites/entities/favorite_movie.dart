import 'package:equatable/equatable.dart';
import '../../movies/entities/movie.dart';

class FavoriteMovie extends Equatable {
  final int? id;
  final int movieId;
  final String title;
  final String? posterPath;
  final String? overview;
  final String releaseDate;
  final double voteAverage;
  final int profileId;
  final DateTime createdAt;

  const FavoriteMovie({
    this.id,
    required this.movieId,
    required this.title,
    this.posterPath,
    this.overview,
    required this.releaseDate,
    required this.voteAverage,
    required this.profileId,
    required this.createdAt,
  });

  // Convert to Movie entity
  Movie toMovie() {
    return Movie(
      id: movieId,
      title: title,
      overview: overview ?? '',
      posterPath: posterPath,
      backdropPath: null,
      voteAverage: voteAverage,
      voteCount: 0,
      releaseDate: releaseDate,
      genreIds: const [],
      popularity: 0.0,
    );
  }

  // Create from Movie entity
  factory FavoriteMovie.fromMovie(Movie movie, int profileId) {
    return FavoriteMovie(
      movieId: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      overview: movie.overview,
      releaseDate: movie.releaseDate,
      voteAverage: movie.voteAverage,
      profileId: profileId,
      createdAt: DateTime.now(),
    );
  }

  String get posterUrl => posterPath != null 
      ? 'https://image.tmdb.org/t/p/w500$posterPath' 
      : '';

  @override
  List<Object?> get props => [
    id, movieId, title, posterPath, overview,
    releaseDate, voteAverage, profileId, createdAt
  ];
}