import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies({int page = 1});
  Future<List<MovieModel>> getTopRatedMovies({int page = 1});
  Future<List<MovieModel>> getUpcomingMovies({int page = 1});
  Future<List<MovieModel>> searchMovies(String query, {int page = 1});
  Future<MovieModel> getMovieDetails(int movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl(this.dio);

  @override
  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    return _getMovies('/movie/popular', page);
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies({int page = 1}) async {
    return _getMovies('/movie/top_rated', page);
  }

  @override
  Future<List<MovieModel>> getUpcomingMovies({int page = 1}) async {
    return _getMovies('/movie/upcoming', page);
  }

  @override
  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await dio.get('/search/movie', queryParameters: {
        'query': query,
        'page': page,
      });

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to search movies');
      }
    } on DioException catch (e) {
      throw ServerException('Network error: ${e.message}');
    }
  }

  @override
  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      final response = await dio.get('/movie/$movieId');

      if (response.statusCode == 200) {
        return MovieModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to get movie details');
      }
    } on DioException catch (e) {
      throw ServerException('Network error: ${e.message}');
    }
  }

  Future<List<MovieModel>> _getMovies(String endpoint, int page) async {
    try {
      final response = await dio.get(endpoint, queryParameters: {'page': page});

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load movies');
      }
    } on DioException catch (e) {
      throw ServerException('Network error: ${e.message}');
    }
  }
}