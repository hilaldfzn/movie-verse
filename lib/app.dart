import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'application/auth/bloc/auth_bloc.dart';
import 'application/auth/profile/bloc/profile_bloc.dart';
import 'application/movies/bloc/movie_bloc.dart';
import 'application/movies/search/bloc/search_bloc.dart';
import 'application/favorites/bloc/favorites_bloc.dart';
import 'core/utils/app_theme.dart';
import 'presentation/core/router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.instance<AuthBloc>()),
        BlocProvider(create: (_) => GetIt.instance<ProfileBloc>()),
        BlocProvider(create: (_) => GetIt.instance<MovieBloc>()),
        BlocProvider(create: (_) => GetIt.instance<SearchBloc>()),
        BlocProvider(create: (_) => GetIt.instance<FavoritesBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Movie App',
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}