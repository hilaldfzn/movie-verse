import 'package:flutter/material.dart';

enum MovieCategory {
  popular,
  topRated,
  upcoming,
  nowPlaying,
}

class CategoryTabs extends StatelessWidget {
  final MovieCategory selectedCategory;
  final Function(MovieCategory) onCategoryChanged;

  const CategoryTabs({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      onTap: (index) {
        final categories = MovieCategory.values;
        if (index < categories.length) {
          onCategoryChanged(categories[index]);
        }
      },
      tabs: const [
        Tab(text: 'Popular'),
        Tab(text: 'Top Rated'),
        Tab(text: 'Upcoming'),
        Tab(text: 'Now Playing'),
      ],
    );
  }

  static String getCategoryName(MovieCategory category) {
    switch (category) {
      case MovieCategory.popular:
        return 'Popular';
      case MovieCategory.topRated:
        return 'Top Rated';
      case MovieCategory.upcoming:
        return 'Upcoming';
      case MovieCategory.nowPlaying:
        return 'Now Playing';
    }
  }
}