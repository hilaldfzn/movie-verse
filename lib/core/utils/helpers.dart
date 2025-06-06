import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/movies/entities/movie.dart';

class AppHelpers {
  // Date formatting
  static String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Unknown';
    
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  static String formatYear(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Unknown';
    
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  // Rating helpers
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  static Color getRatingColor(double rating) {
    if (rating >= 7.0) return Colors.green;
    if (rating >= 5.0) return Colors.orange;
    return Colors.red;
  }

  // Text helpers
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Genre helpers
  static String getGenreNames(List<int> genreIds) {
    final genreMap = {
      28: 'Action',
      12: 'Adventure',
      16: 'Animation',
      35: 'Comedy',
      80: 'Crime',
      99: 'Documentary',
      18: 'Drama',
      10751: 'Family',
      14: 'Fantasy',
      36: 'History',
      27: 'Horror',
      10402: 'Music',
      9648: 'Mystery',
      10749: 'Romance',
      878: 'Science Fiction',
      10770: 'TV Movie',
      53: 'Thriller',
      10752: 'War',
      37: 'Western',
    };

    final genres = genreIds
        .map((id) => genreMap[id])
        .where((genre) => genre != null)
        .take(3)
        .join(', ');

    return genres.isEmpty ? 'Unknown' : genres;
  }

  // Image helpers
  static String getImageUrl(String? path, {bool isOriginal = false}) {
    if (path == null || path.isEmpty) {
      return 'https://via.placeholder.com/500x750/1f2937/9ca3af?text=No+Image';
    }
    
    final baseUrl = isOriginal 
        ? 'https://image.tmdb.org/t/p/original'
        : 'https://image.tmdb.org/t/p/w500';
    
    return '$baseUrl$path';
  }

  // Validation helpers
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidUsername(String username) {
    return username.length >= 3 && RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username);
  }

  // UI helpers
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Runtime type helpers
  static String getRuntime(int? runtime) {
    if (runtime == null || runtime == 0) return 'Unknown';
    
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}min';
    } else {
      return '${minutes}min';
    }
  }

  // Number formatting
  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  // Share movie helper
  static String generateShareText(Movie movie) {
    return '''
🎬 ${movie.title}

⭐ Rating: ${formatRating(movie.voteAverage)}/10
📅 Release: ${formatDate(movie.releaseDate)}

${truncateText(movie.overview, 150)}

Check it out: movieapp.com/movie/${movie.id}

#Movies #Cinema #${movie.title.replaceAll(' ', '')}
''';
  }

  // Deep link helpers
  static String generateMovieDeepLink(int movieId) {
    return 'movieapp.com/movie/$movieId';
  }

  static String generateSearchDeepLink(String query) {
    return 'movieapp.com/search?q=${Uri.encodeComponent(query)}';
  }
}

// Extension methods
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String toTitleCase() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
}

extension ListExtension<T> on List<T> {
  List<T> safeSublist(int start, [int? end]) {
    if (start >= length) return [];
    final actualEnd = end != null ? (end > length ? length : end) : length;
    return sublist(start, actualEnd);
  }
}