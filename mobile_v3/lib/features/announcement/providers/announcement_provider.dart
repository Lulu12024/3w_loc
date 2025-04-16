// lib/features/announcement/providers/announcement_provider.dart
import 'package:flutter/material.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../models/announcement.dart';

class AnnouncementProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  List<Announcement> _announcements = [];
  bool _isLoading = false;

  List<Announcement> get announcements => [..._announcements];
  bool get isLoading => _isLoading;

  Future<List<Announcement>> fetchAnnouncements({String? category, String? search, String? location}) async {
    try {
      _isLoading = true;
      notifyListeners();

      Map<String, dynamic> queryParams = {};
      if (category != null && category != 'Tous') {
        queryParams['category'] = category;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (location != null && location.isNotEmpty) {
        queryParams['location'] = location;
      }

      final response = await _apiClient.get(
        ApiEndpoints.announcements,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _announcements = data.map((json) => Announcement.fromJson(json)).toList();
        notifyListeners();
        return _announcements;
      } else {
        throw Exception('Failed to load announcements');
      }
    } catch (e) {
      throw Exception('Error fetching announcements: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Announcement> fetchAnnouncementById(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get(ApiEndpoints.announcement(id));

      if (response.statusCode == 200) {
        return Announcement.fromJson(response.data);
      } else {
        throw Exception('Failed to load announcement');
      }
    } catch (e) {
      throw Exception('Error fetching announcement: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Announcement> createAnnouncement(Announcement announcement) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.post(
        ApiEndpoints.announcements,
        data: announcement.toJson(),
      );

      if (response.statusCode == 201) {
        final newAnnouncement = Announcement.fromJson(response.data);
        _announcements.add(newAnnouncement);
        notifyListeners();
        return newAnnouncement;
      } else {
        throw Exception('Failed to create announcement');
      }
    } catch (e) {
      throw Exception('Error creating announcement: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Announcement> updateAnnouncement(Announcement announcement) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.put(
        ApiEndpoints.updateAnnouncement(announcement.id),
        data: announcement.toJson(),
      );

      if (response.statusCode == 200) {
        final updatedAnnouncement = Announcement.fromJson(response.data);
        final index = _announcements.indexWhere((a) => a.id == announcement.id);
        if (index != -1) {
          _announcements[index] = updatedAnnouncement;
        }
        notifyListeners();
        return updatedAnnouncement;
      } else {
        throw Exception('Failed to update announcement');
      }
    } catch (e) {
      throw Exception('Error updating announcement: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.delete(ApiEndpoints.deleteAnnouncement(id));

      if (response.statusCode == 204) {
        _announcements.removeWhere((a) => a.id == id);
        notifyListeners();
      } else {
        throw Exception('Failed to delete announcement');
      }
    } catch (e) {
      throw Exception('Error deleting announcement: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}