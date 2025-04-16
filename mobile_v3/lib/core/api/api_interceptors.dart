// lib/core/api/api_interceptors.dart
import 'package:dio/dio.dart';
import '../storage/local_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add JWT token to requests if available
    final token = await LocalStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    // Handle API errors (e.g., 401 Unauthorized)
    if (error.response?.statusCode == 401) {
      // Token expired, redirect to login page
      await LocalStorage.clearToken();
      // You'll need a mechanism to navigate to the login page here
      // This could involve using a navigation service or a callback
    }
    return handler.next(error);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return handler.next(err);
  }
}