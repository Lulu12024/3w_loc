// lib/features/profile/providers/profile_provider.dart
import 'package:flutter/material.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../auth/models/user.dart';

class ProfileProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> updateUserProfile(User user) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.put(
        ApiEndpoints.updateUser(user.id),
        data: user.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      throw Exception('Error updating profile: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadProfilePicture(String userId, dynamic imageFile) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Créer un FormData pour l'upload de l'image
      final formData = {
        'user_id': userId,
        'photo_profil': imageFile,
      };

      final response = await _apiClient.post(
        '/api/users/upload-photo/',
        data: formData,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to upload profile picture');
      }
    } catch (e) {
      throw Exception('Error uploading profile picture: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<dynamic>> getUserRatings(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/api/users/$userId/ratings/');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load user ratings');
      }
    } catch (e) {
      throw Exception('Error fetching user ratings: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitUserVerification(String userId, Map<String, dynamic> verificationData) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.post(
        ApiEndpoints.submitVerification,
        data: {
          'user_id': userId,
          ...verificationData,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to submit verification');
      }
    } catch (e) {
      throw Exception('Error submitting verification: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}