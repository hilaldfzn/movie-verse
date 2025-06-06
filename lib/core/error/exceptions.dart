class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message ${code != null ? '($code)' : ''}';
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message, code: 'NETWORK_ERROR');
}

class ServerException extends AppException {
  final int? statusCode;
  
  ServerException(String message, {this.statusCode}) 
      : super(message, code: 'SERVER_ERROR');
}

class CacheException extends AppException {
  CacheException(String message) : super(message, code: 'CACHE_ERROR');
}

class ValidationException extends AppException {
  ValidationException(String message) : super(message, code: 'VALIDATION_ERROR');
}

class AuthException extends AppException {
  AuthException(String message) : super(message, code: 'AUTH_ERROR');
}

class NotFoundException extends AppException {
  NotFoundException(String message) : super(message, code: 'NOT_FOUND');
}