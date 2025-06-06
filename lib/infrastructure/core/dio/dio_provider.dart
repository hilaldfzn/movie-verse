import 'package:dio/dio.dart';

part '_api_key.dart';

class DioProvider {
  static Dio createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      queryParameters: {'api_key': _apiKey},
    ));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    return dio;
  }
}