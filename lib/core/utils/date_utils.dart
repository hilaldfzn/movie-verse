import 'package:intl/intl.dart';

class AppDateUtils {
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String yearFormat = 'yyyy';

  static String formatForDisplay(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Unknown';
    
    try {
      final date = DateTime.parse(dateString);
      return DateFormat(displayDateFormat).format(date);
    } catch (e) {
      return dateString;
    }
  }

  static String formatYear(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Unknown';
    
    try {
      final date = DateTime.parse(dateString);
      return DateFormat(yearFormat).format(date);
    } catch (e) {
      return dateString;
    }
  }

  static DateTime? parseApiDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  static String formatForApi(DateTime date) {
    return DateFormat(apiDateFormat).format(date);
  }

  static bool isValidDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return false;
    
    try {
      DateTime.parse(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  static int daysBetween(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  static bool isThisYear(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year;
  }

  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}