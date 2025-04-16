// lib/features/booking/models/booking.dart
import 'package:intl/intl.dart';
import '../../announcement/models/announcement.dart';
import '../../auth/models/user.dart';

class Booking {
  final String id;
  final DateTime dateReservation;
  final DateTime dateFin;
  final String status;
  final Announcement announcement;
  final User locataire;

  Booking({
    required this.id,
    required this.dateReservation,
    required this.dateFin,
    required this.status,
    required this.announcement,
    required this.locataire,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      dateReservation: DateTime.parse(json['date_reservation']),
      dateFin: DateTime.parse(json['date_fin']),
      status: json['status'],
      announcement: Announcement.fromJson(json['annonce']),
      locataire: User.fromJson(json['locataire']),
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return {
      'id': id,
      'date_reservation': formatter.format(dateReservation),
      'date_fin': formatter.format(dateFin),
      'status': status,
      'annonce': announcement.toJson(),
      'locataire': locataire.toJson(),
    };
  }
}