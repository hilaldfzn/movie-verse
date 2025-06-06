import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

// Core
import 'core/network/network_info.dart';
import 'infrastructure/core/database/database_helper.dart';
import 'infrastructure/core/database/app_database.dart';
import 'infrastructure/core/dio/dio_provider.dart';

// Auth
import 'domain/auth/repositories/auth_repository.dart';
import 'infrastructure/auth/repositories/auth_repository_impl.dart';
import 'infrastructure/auth/datasources/auth_local_datasource.dart';
import 'domain/auth/usecases/login_user.dart';
import 'domain/auth/usecases/create_profile.dart';
import 'domain/auth/usecases/get_profiles.dart';
import 'application/auth/bloc/auth_bloc.dart';
import 'application/auth/profile/bloc/profile_bloc.dart';

// Movies
import 'domain/movies/repositories/movie_repository.dart';
import 'infrastructure/movies/repositories/movie_repository_impl.dart';
import 'infrastructure/movies/datasources/movie_remote_datasource.dart';
import 'domain/movies/usecases/get_popular_movies.dart';
import 'domain/movies/usecases/search_movies.dart';
import 'domain/movies/usecases/get_movie_details.dart';
import 'application/movies/bloc/movie_bloc.dart';
import 'application/movies/search/bloc/search_bloc.dart';

// Favorites
import 'domain/favorites/repositories/favorites_repository.dart';
import 'infrastructure/favorites/repositories/favorites_repository_impl.dart';
import 'infrastructure/favorites/datasources/favorites_local_datasource.dart';
import 'domain/favorites/usecases/add_to_favorites.dart';
import 'domain/favorites/usecases/remove_from_favorites.dart';
import 'domain/favorites/usecases/get_favorites.dart';
import 'domain/favorites/usecases/check_favorite_status.dart';
import 'application/favorites/bloc/favorites_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
  
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => DioProvider.createDio());
  
  //! Database
  final database = await DatabaseHelper.initDatabase();
  sl.registerLazySingleton<Database>(() => database);
  sl.registerLazySingleton(() => AppDatabase());
  
  //! Data sources
  // Auth
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  
  // Movies
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(sl()),
  );
  
  // Favorites
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(sl()),
  );
  
  //! Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );
  
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: sl()),
  );
  
  //! Use cases
  // Auth
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => CreateProfile(sl()));
  sl.registerLazySingleton(() => GetProfiles(sl()));
  
  // Movies
  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetails(sl()));
  
  // Favorites
  sl.registerLazySingleton(() => AddToFavorites(sl()));
  sl.registerLazySingleton(() => RemoveFromFavorites(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => CheckFavoriteStatus(sl()));
  
  //! BLoCs
  sl.registerFactory(() => AuthBloc(
    loginUser: sl(),
    createProfile: sl(),
    getProfiles: sl(),
  ));
  
  sl.registerFactory(() => ProfileBloc(
    createProfile: sl(),
    getProfiles: sl(),
    authRepository: sl(),
  ));
  
  sl.registerFactory(() => MovieBloc(
    getPopularMovies: sl(),
    searchMovies: sl(),
    getMovieDetails: sl(),
  ));
  
  sl.registerFactory(() => SearchBloc(
    searchMovies: sl(),
  ));
  
  sl.registerFactory(() => FavoritesBloc(
    addToFavorites: sl(),
    removeFromFavorites: sl(),
    getFavorites: sl(),
    checkFavoriteStatus: sl(),
  ));
}