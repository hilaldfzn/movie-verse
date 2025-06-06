import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../../../application/movies/bloc/movie_bloc.dart';
import '../../../application/favorites/bloc/favorites_bloc.dart';
import '../../../application/auth/profile/bloc/profile_bloc.dart';
import '../../../core/utils/helpers.dart';
import '../../../domain/movies/entities/movie.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool _isFavorite = false;
  int? _currentProfileId;

  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(GetMovieDetailsEvent(widget.movieId));
    _getCurrentProfile();
  }

  void _getCurrentProfile() {
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileSelected) {
      _currentProfileId = profileState.profile.id;
      _checkFavoriteStatus();
    }
  }

  void _checkFavoriteStatus() {
    if (_currentProfileId != null) {
      context.read<FavoritesBloc>().add(CheckFavoriteStatusEvent(
        movieId: widget.movieId,
        profileId: _currentProfileId!,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<FavoritesBloc, FavoritesState>(
            listener: (context, state) {
              if (state is FavoriteStatusChecked) {
                setState(() {
                  _isFavorite = state.isFavorite;
                });
              } else if (state is FavoriteAdded) {
                setState(() {
                  _isFavorite = true;
                });
                AppHelpers.showSnackBar(context, 'Added to favorites');
              } else if (state is FavoriteRemoved) {
                setState(() {
                  _isFavorite = false;
                });
                AppHelpers.showSnackBar(context, 'Removed from favorites');
              }
            },
          ),
        ],
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MovieError) {
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
                      onPressed: () => context.read<MovieBloc>()
                          .add(GetMovieDetailsEvent(widget.movieId)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is MovieDetailsLoaded) {
              return _buildMovieDetails(state.movie);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildMovieDetails(Movie movie) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: AppHelpers.getImageUrl(movie.backdropPath, isOriginal: true),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[800],
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.movie, size: 100),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : Colors.white,
              ),
              onPressed: () => _toggleFavorite(movie),
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareMovie(movie),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppHelpers.getRatingColor(movie.voteAverage),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        AppHelpers.formatRating(movie.voteAverage),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(AppHelpers.formatDate(movie.releaseDate)),
                    const SizedBox(width: 16),
                    Text('${AppHelpers.formatNumber(movie.voteCount)} votes'),
                  ],
                ),
                const SizedBox(height: 16),
                if (movie.genreIds.isNotEmpty) ...[
                  const Text(
                    'Genres',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppHelpers.getGenreNames(movie.genreIds),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                ],
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.overview.isNotEmpty
                      ? movie.overview
                      : 'No overview available.',
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Movie Details',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow('Popularity', movie.popularity.toStringAsFixed(1)),
                        _buildDetailRow('Vote Count', AppHelpers.formatNumber(movie.voteCount)),
                        _buildDetailRow('Release Date', AppHelpers.formatDate(movie.releaseDate)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(Movie movie) {
    if (_currentProfileId == null) return;

    if (_isFavorite) {
      context.read<FavoritesBloc>().add(RemoveFromFavoritesEvent(
        movieId: movie.id,
        profileId: _currentProfileId!,
      ));
    } else {
      context.read<FavoritesBloc>().add(AddToFavoritesEvent(
        movie: movie,
        profileId: _currentProfileId!,
      ));
    }
  }

  void _shareMovie(Movie movie) {
    final text = AppHelpers.generateShareText(movie);
    Share.share(text, subject: movie.title);
  }
}