import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../domain/movies/entities/movie.dart';
import '../../../domain/movies/repositories/movie_repository.dart';
import '../datasources/movie_remote_datasource.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.getPopularMovies(page: page);
        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies({int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.getTopRatedMovies(page: page);
        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getUpcomingMovies({int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.getUpcomingMovies(page: page);
        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query, {int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.searchMovies(query, page: page);
        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails(int movieId) async {
    if (await networkInfo.isConnected) {
      try {
        final movie = await remoteDataSource.getMovieDetails(movieId);
        return Right(movie);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}