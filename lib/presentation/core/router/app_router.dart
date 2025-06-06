import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/route_constants.dart';
import '../../auth/pages/login_page.dart';
import '../../auth/pages/profile_selection_page.dart';
import '../../movies/pages/movie_list_page.dart';
import '../../movies/pages/movie_detail_page.dart';
import '../../movies/pages/search_page.dart';
import '../../favorites/pages/favorites_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteConstants.login,
    routes: [
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteConstants.profileSelection,
        name: 'profile-selection',
        builder: (context, state) => const ProfileSelectionPage(),
      ),
      GoRoute(
        path: RouteConstants.movieList,
        name: 'movie-list',
        builder: (context, state) => const MovieListPage(),
      ),
      GoRoute(
        path: '${RouteConstants.movieDetail}/:id',
        name: 'movie-detail',
        builder: (context, state) {
          final movieId = int.parse(state.pathParameters['id']!);
          return MovieDetailPage(movieId: movieId);
        },
      ),
      GoRoute(
        path: RouteConstants.search,
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: RouteConstants.favorites,
        name: 'favorites',
        builder: (context, state) => const FavoritesPage(),
      ),
    ],
  );
}