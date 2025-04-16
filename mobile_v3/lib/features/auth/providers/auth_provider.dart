// lib/features/auth/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/storage/local_storage.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  ApiClient _apiClient = ApiClient();
  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _autoLogin();
  }

  Future<void> _autoLogin() async {
    final token = await LocalStorage.getToken();
    if (token == null) return;

    try {
      // Vérifier si le token est expiré
      final isExpired = JwtDecoder.isExpired(token);
      if (isExpired) {
        await _refreshToken();
      } else {
        final userData = await LocalStorage.getUserData();
        if (userData != null) {
          _user = User.fromJson(json.decode(userData));
          _isAuthenticated = true;
          notifyListeners();
        }
      }
    } catch (e) {
      await LocalStorage.clearAll();
    }
  }

  Future<void> _refreshToken() async {
    try {
      final refreshToken = await LocalStorage.getRefreshToken();
      if (refreshToken == null) {
        throw Exception('Refresh token not found');
      }

      final response = await _apiClient.post(
        ApiEndpoints.tokenRefresh,
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        await LocalStorage.saveToken(response.data['access']);
        
        final userData = await LocalStorage.getUserData();
        if (userData != null) {
          _user = User.fromJson(json.decode(userData));
          _isAuthenticated = true;
          notifyListeners();
        }
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      await LocalStorage.clearAll();
      _isAuthenticated = false;
      _user = null;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
    // Afficher les données d'authentification à des fins de débogage
      print('Trying to log in with: $email, $password');
      
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      // Afficher la réponse brute pour le débogage
      print('API Response: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Vérifiez si la réponse contient les données nécessaires
        if (data == null) {
          throw Exception('Empty response from server');
        }
        
        // Récupérer et stocker les tokens
        if (data['accesstoken'] != null && data['accesstoken']['token'] != null) {
          final accessToken = data['accesstoken']['token'];
          final refreshToken = data['accesstoken']['refresh_token'];
          
          await LocalStorage.saveToken(accessToken);
          await LocalStorage.saveRefreshToken(refreshToken);
        } else {
          throw Exception('No token found in response');
        }
        
        // Récupérer les données utilisateur
        if (data['user'] != null) {
          final userData = data['user'];
          _user = User.fromJson(userData);
          await LocalStorage.saveUserData(json.encode(userData));
          _isAuthenticated = true;
          notifyListeners();
        } else {
          throw Exception('User data not found in response');
        }
      } else {
        throw Exception('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Login error details: $e');
      throw Exception('Login error: ${e.toString()}');
    }
  }
  Future<void> signup(User user, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.signup,
        data: {
          ...user.toJson(),
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        // Après inscription réussie, connecter l'utilisateur
        await login(user.email, password);
      } else {
        throw Exception('Signup failed');
      }
    } catch (e) {
      throw Exception('Signup error: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (e) {
      // Ignorer les erreurs lors de la déconnexion du serveur
    } finally {
      await LocalStorage.clearAll();
      _isAuthenticated = false;
      _user = null;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.passwordReset,
        data: {'email': email},
      );

      if (response.statusCode != 200) {
        throw Exception('Password reset request failed');
      }
    } catch (e) {
      throw Exception('Password reset error: ${e.toString()}');
    }
  }

  Future<void> confirmResetPassword(String token, String newPassword) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.passwordResetConfirm,
        data: {
          'token': token,
          'new_password': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Password reset confirmation failed');
      }
    } catch (e) {
      throw Exception('Password reset confirmation error: ${e.toString()}');
    }
  }

  Future<void> updateUserProfile(User updatedUser) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.updateUser(updatedUser.id),
        data: updatedUser.toJson(),
      );

      if (response.statusCode == 200) {
        _user = updatedUser;
        await LocalStorage.saveUserData(json.encode(updatedUser.toJson()));
        notifyListeners();
      } else {
        throw Exception('Update profile failed');
      }
    } catch (e) {
      throw Exception('Update profile error: ${e.toString()}');
    }
  }
}