import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../application/favorites/bloc/favorites_bloc.dart';
import '../../../application/auth/profile/bloc/profile_bloc.dart';
import '../../../core/constants/route_constants.dart';
import '../widgets/favorite_movie_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileSelected) {
      context.read<FavoritesBloc>().add(
        LoadFavoritesEvent(profileState.profile.id!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: BlocListener<FavoritesBloc, FavoritesState>(
        listener: (context, state) {
          if (state is FavoriteRemoved) {
            _loadFavorites(); // Reload favorites after removal
          }
        },
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FavoritesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadFavorites,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is FavoritesLoaded) {
              if (state.favorites.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Movies you favorite will appear here',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  final favorite = state.favorites[index];
                  return FavoriteMovieCard(
                    favorite: favorite,
                    onTap: () => context.go(
                      '${RouteConstants.movieDetail}/${favorite.movieId}',
                    ),
                    onRemove: () => _removeFavorite(favorite.movieId),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  void _removeFavorite(int movieId) {
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileSelected) {
      context.read<FavoritesBloc>().add(RemoveFromFavoritesEvent(
        movieId: movieId,
        profileId: profileState.profile.id!,
      ));
    }
  }
}