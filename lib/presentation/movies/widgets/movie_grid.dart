import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../domain/movies/entities/movie.dart';
import 'movie_card.dart';

class MovieGrid extends StatelessWidget {
  final PagingController<int, Movie> pagingController;
  final Function(Movie) onMovieTap;

  const MovieGrid({
    super.key,
    required this.pagingController,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return PagedGridView<int, Movie>(
      pagingController: pagingController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      builderDelegate: PagedChildBuilderDelegate<Movie>(
        itemBuilder: (context, movie, index) => MovieCard(
          movie: movie,
          onTap: () => onMovieTap(movie),
        ),
        firstPageErrorIndicatorBuilder: (context) => _buildErrorWidget(),
        newPageErrorIndicatorBuilder: (context) => _buildNewPageErrorWidget(),
        firstPageProgressIndicatorBuilder: (context) => 
            const Center(child: CircularProgressIndicator()),
        newPageProgressIndicatorBuilder: (context) => 
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
        noItemsFoundIndicatorBuilder: (context) => _buildEmptyWidget(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Failed to load movies'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => pagingController.refresh(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNewPageErrorWidget() {
    return InkWell(
      onTap: () => pagingController.retryLastFailedRequest(),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: const Column(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(height: 8),
            Text('Failed to load more. Tap to retry.'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No movies found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}