import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../application/movies/bloc/movie_bloc.dart';
import '../../../core/constants/route_constants.dart';
import '../../../domain/movies/entities/movie.dart';
import '../widgets/movie_card.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PagingController<int, Movie> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    // Load initial data
    context.read<MovieBloc>().add(const GetPopularMoviesEvent());
  }

  Future<void> _fetchPage(int pageKey) async {
    context.read<MovieBloc>().add(GetPopularMoviesEvent(page: pageKey));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Popular'),
            Tab(text: 'Top Rated'),
            Tab(text: 'Upcoming'),
          ],
          onTap: (index) {
            _pagingController.refresh();
            switch (index) {
              case 0:
                context.read<MovieBloc>().add(const GetPopularMoviesEvent());
                break;
              case 1:
                context.read<MovieBloc>().add(const GetTopRatedMoviesEvent());
                break;
              case 2:
                context.read<MovieBloc>().add(const GetUpcomingMoviesEvent());
                break;
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go(RouteConstants.search),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.go(RouteConstants.favorites),
          ),
        ],
      ),
      body: BlocListener<MovieBloc, MovieState>(
        listener: (context, state) {
          if (state is MovieLoaded) {
            final isLastPage = state.movies.length < 20;
            if (isLastPage) {
              _pagingController.appendLastPage(state.movies);
            } else {
              final nextPageKey = (state.page ?? 1) + 1;
              _pagingController.appendPage(state.movies, nextPageKey);
            }
          } else if (state is MovieError) {
            _pagingController.error = state.message;
          }
        },
        child: PagedGridView<int, Movie>(
          pagingController: _pagingController,
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
              onTap: () => context.go('${RouteConstants.movieDetail}/${movie.id}'),
            ),
            firstPageErrorIndicatorBuilder: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${_pagingController.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _pagingController.refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pagingController.dispose();
    super.dispose();
  }
}