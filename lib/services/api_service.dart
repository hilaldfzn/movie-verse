import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:movie_verse/models/movie.dart';

class ApiService {
  static const String apiKey = '8180f4197351e2680699ea4f534d763a';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  Future<void> getPopularMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      // Membuka box Hive untuk menyimpan data movies
      var movieBox = await Hive.openBox<Movie>('movies');

      // Menyimpan movies di Hive
      for (var movieJson in data) {
        var movie = Movie.fromJson(movieJson);
        await movieBox.put(movie.title, movie);
      }
    } else {
       // Tambahkan log untuk melihat respons API
        print('Failed to load movies. Status Code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load movies');
    }
  }
}