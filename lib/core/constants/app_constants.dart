class AppConstants {
  static const String appName = 'Movie App';
  static const String baseImageUrl = 'https://image.tmdb.org/t/p/w500';
  static const String originalImageUrl = 'https://image.tmdb.org/t/p/original';
  static const String noImageUrl = 'https://via.placeholder.com/500x750/1f2937/9ca3af?text=No+Image';
  
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  
  static const int pageSize = 20;
  
  static Map<int, String> genreMap = {
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
}