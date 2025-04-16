// lib/features/booking/providers/booking_provider.dart
import 'package:flutter/material.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../models/booking.dart';
import 'package:intl/intl.dart';

class BookingProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  List<Booking> _bookings = [];
  bool _isLoading = false;

  List<Booking> get bookings => [..._bookings];
  bool get isLoading => _isLoading;

  Future<List<Booking>> fetchUserBookings() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get(ApiEndpoints.bookings);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _bookings = data.map((json) => Booking.fromJson(json)).toList();
        notifyListeners();
        return _bookings;
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      throw Exception('Error fetching bookings: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Booking> fetchBookingById(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.booking(id));

      if (response.statusCode == 200) {
        return Booking.fromJson(response.data);
      } else {
        throw Exception('Failed to load booking');
      }
    } catch (e) {
      throw Exception('Error fetching booking: ${e.toString()}');
    }
  }

  Future<Booking> createBooking(
    String announcementId,
    DateTime startDate,
    DateTime endDate,
    bool isDelivery,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final response = await _apiClient.post(
        ApiEndpoints.bookings,
        data: {
          'annonce': announcementId,
          'date_reservation': formatter.format(startDate),
          'date_fin': formatter.format(endDate),
          'status': isDelivery ? 'delivery' : 'pickup',
        },
      );

      if (response.statusCode == 201) {
        final newBooking = Booking.fromJson(response.data);
        _bookings.add(newBooking);
        notifyListeners();
        return newBooking;
      } else {
        throw Exception('Failed to create booking');
      }
    } catch (e) {
      throw Exception('Error creating booking: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Booking> updateBookingStatus(String id, String status) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.put(
        ApiEndpoints.updateBooking(id),
        data: {
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        final updatedBooking = Booking.fromJson(response.data);
        final index = _bookings.indexWhere((b) => b.id == id);
        if (index != -1) {
          _bookings[index] = updatedBooking;
        }
        notifyListeners();
        return updatedBooking;
      } else {
        throw Exception('Failed to update booking status');
      }
    } catch (e) {
      throw Exception('Error updating booking status: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelBooking(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.delete(ApiEndpoints.deleteBooking(id));

      if (response.statusCode == 204) {
        _bookings.removeWhere((b) => b.id == id);
        notifyListeners();
      } else {
        throw Exception('Failed to cancel booking');
      }
    } catch (e) {
      throw Exception('Error canceling booking: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}