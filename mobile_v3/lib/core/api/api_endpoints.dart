// lib/core/api/api_endpoints.dart
class ApiEndpoints {
  // static const String baseUrl = 'https://votre-api-backend.com/api';
  static const String baseUrl = 'http://10.0.2.2:8007/api' ;
  
  // Authentification
  static const String signup = '/signup/';
  static const String login = '/login/';
  static const String logout = '/logout/';
  static const String passwordReset = '/password/reset/';
  static const String passwordResetConfirm = '/password/reset/confirm/';
  static const String tokenRefresh = '/token/refresh/';
  
  // Utilisateurs
  static const String users = '/users/';
  static String user(String id) => '/users/$id/';
  static String updateUser(String id) => '/users/update/$id/';
  
  // Annonces
  static const String announcements = '/announcements/';
  static String announcement(String id) => '/announcements/$id/';
  static String updateAnnouncement(String id) => '/announcements/$id/update/';
  static String deleteAnnouncement(String id) => '/announcements/$id/delete/';
  
  // Réservations
  static const String bookings = '/bookings/';
  static String booking(String id) => '/bookings/$id/';
  static String updateBooking(String id) => '/bookings/update/$id/';
  static String deleteBooking(String id) => '/bookings/delete/$id/';
  
  // Catégories
  static const String categories = '/category/';
  static String category(String id) => '/category/id/$id/';
  
  // Sous-catégories
  static const String subcategories = '/subcategory/';
  static String subcategory(String id) => '/subcategory/id/$id/';
  
  // Documents et vérification
  static const String uploadDocuments = '/documents/upload/';
  static const String submitVerification = '/verification/submit/';
}