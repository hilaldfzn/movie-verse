import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../application/movies/search/bloc/search_bloc.dart';
import '../../../core/constants/route_constants.dart';
import '../../../domain/movies/entities/movie.dart';
import '../widgets/movie_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final PagingController<int, Movie> _pagingController =
      PagingController(firstPageKey: 1);
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_fetchPage);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  void _fetchPage(int pageKey) {
    if (_currentQuery.isNotEmpty) {
      context.read<SearchBloc>().add(SearchMoviesLoadMore(
        query: _currentQuery,
        page: pageKey,
      ));
    }
  }

  void _onSearchChanged(String query) {
    if (query != _currentQuery) {
      _currentQuery = query;
      _pagingController.refresh();
      
      if (query.trim().isNotEmpty) {
        context.read<SearchBloc>().add(SearchMoviesStarted(query));
      } else {
        context.read<SearchBloc>().add(SearchMoviesCleared());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
          onChanged: _onSearchChanged,
        ),
      ),
      body: BlocListener<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state is SearchLoaded) {
            final isLastPage = state.hasReachedMax;
            if (isLastPage) {
              _pagingController.appendLastPage(state.movies);
            } else {
              final nextPageKey = state.currentPage + 1;
              _pagingController.appendPage(state.movies, nextPageKey);
            }
          } else if (state is SearchError) {
            _pagingController.error = state.message;
          } else if (state is SearchEmpty) {
            _pagingController.appendLastPage([]);
          } else if (state is SearchInitial) {
            _pagingController.refresh();
          }
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchInitial) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Search for movies',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            if (state is SearchEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No movies found for "${state.query}"',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return PagedGridView<int, Movie>(
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
                firstPageProgressIndicatorBuilder: (context) => 
                    const Center(child: CircularProgressIndicator()),
                newPageProgressIndicatorBuilder: (context) => 
                    const Center(child: CircularProgressIndicator()),
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
            );
          },
        ),
      ),
    );
  }
}