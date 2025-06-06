import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'core/network/network_info.dart';
import 'infrastructure/core/storage/in_memory_storage.dart';
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
  print('🚀 Initializing app dependencies...');
  
  //! External dependencies
  print('📦 Setting up external dependencies...');
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
  
  //! Core
  print('⚙️ Setting up core services...');
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => DioProvider.createDio());
  
  //! In-Memory Storage
  print('💾 Setting up in-memory storage...');
  final storage = InMemoryStorage();
  await storage.init(sharedPreferences);
  sl.registerLazySingleton(() => storage);
  
  //! Data sources
  print('🔌 Setting up data sources...');
  // Auth
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: sl(),
      storage: sl(),
    ),
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
  print('🏪 Setting up repositories...');
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
  print('🎯 Setting up use cases...');
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
  print('🔄 Setting up state management...');
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
  
  print('✅ All dependencies initialized successfully!');
  
  // Debug info
  storage.printDebugInfo();
}