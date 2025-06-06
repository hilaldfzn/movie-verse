import '../../../domain/favorites/entities/favorite_movie.dart';

class FavoriteMovieModel extends FavoriteMovie {
  const FavoriteMovieModel({
    int? id,
    required int movieId,
    required String title,
    String? posterPath,
    String? overview,
    required String releaseDate,
    required double voteAverage,
    required int profileId,
    required DateTime createdAt,
  }) : super(
          id: id,
          movieId: movieId,
          title: title,
          posterPath: posterPath,
          overview: overview,
          releaseDate: releaseDate,
          voteAverage: voteAverage,
          profileId: profileId,
          createdAt: createdAt,
        );

  factory FavoriteMovieModel.fromJson(Map<String, dynamic> json) {
    return FavoriteMovieModel(
      id: json['id'],
      movieId: json['movieId'],
      title: json['title'],
      posterPath: json['posterPath'],
      overview: json['overview'],
      releaseDate: json['releaseDate'],
      voteAverage: (json['voteAverage'] as num).toDouble(),
      profileId: json['profileId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieId': movieId,
      'title': title,
      'posterPath': posterPath,
      'overview': overview,
      'releaseDate': releaseDate,
      'voteAverage': voteAverage,
      'profileId': profileId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FavoriteMovieModel.fromEntity(FavoriteMovie entity) {
    return FavoriteMovieModel(
      id: entity.id,
      movieId: entity.movieId,
      title: entity.title,
      posterPath: entity.posterPath,
      overview: entity.overview,
      releaseDate: entity.releaseDate,
      voteAverage: entity.voteAverage,
      profileId: entity.profileId,
      createdAt: entity.createdAt,
    );
  }
}