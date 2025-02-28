import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String overview;

  @HiveField(2)
  final String posterPath;

  @HiveField(3)
  final double rating;

  Movie({
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.rating,
  });

   factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      overview: json['overview'],
      posterPath: 'https://image.tmdb.org/t/p/w500' + json['poster_path'],
      rating: json['vote_average'].toDouble(),
    );
  }
}