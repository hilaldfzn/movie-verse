import '../../../domain/movies/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required int id,
    required String title,
    required String overview,
    String? posterPath,
    String? backdropPath,
    required double voteAverage,
    required int voteCount,
    required String releaseDate,
    required List<int> genreIds,
    required double popularity,
  }) : super(
          id: id,
          title: title,
          overview: overview,
          posterPath: posterPath,
          backdropPath: backdropPath,
          voteAverage: voteAverage,
          voteCount: voteCount,
          releaseDate: releaseDate,
          genreIds: genreIds,
          popularity: popularity,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      popularity: (json['popularity'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'genre_ids': genreIds,
      'popularity': popularity,
    };
  }
}