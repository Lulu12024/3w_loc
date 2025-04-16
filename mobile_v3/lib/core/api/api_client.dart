// lib/core/api/api_client.dart
import 'package:dio/dio.dart';
import 'package:w3_loc/core/api/api_interceptors.dart';
import '../storage/local_storage.dart';
import 'api_endpoints.dart';

class ApiClient {
  late Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    ));
    
     // Add interceptors
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(ErrorInterceptor());

    // _dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) async {
    //     // Ajouter le token JWT aux requêtes si disponible
    //     final token = await LocalStorage.getToken();
    //     if (token != null && token.isNotEmpty) {
    //       options.headers['Authorization'] = 'Bearer $token';
    //     }
    //     return handler.next(options);
    //   },
    //   onError: (error, handler) async {
    //     // Gérer les erreurs d'API (ex: 401 Unauthorized)
    //     if (error.response?.statusCode == 401) {
    //       // Token expiré, rediriger vers la page de connexion
    //       LocalStorage.clearToken();
    //       // Vous aurez besoin d'un mécanisme pour naviguer vers la page de connexion ici
    //     }
    //     return handler.next(error);
    //   }
    // ));
  }
  
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }
  
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }
  
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }
  
  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.delete(path, data: data, queryParameters: queryParameters);
  }
}