// lib/features/announcement/models/announcement.dart
import 'package:intl/intl.dart';
import '../../auth/models/user.dart';

class Announcement {
  final String id;
  final String title;
  final String description;
  final List<String> pictures;
  final double rentalPrice;
  final bool status;
  final DateTime availabilityStartDate;
  final DateTime availabilityEndDate;
  final DateTime expirationDate;
  final Category category;
  final String rentalTerms;
  final String location;
  final String? extraOptions;
  final User proprietaire;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.pictures,
    required this.rentalPrice,
    required this.status,
    required this.availabilityStartDate,
    required this.availabilityEndDate,
    required this.expirationDate,
    required this.category,
    required this.rentalTerms,
    required this.location,
    this.extraOptions,
    required this.proprietaire,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      pictures: List<String>.from(json['pictures'] ?? []),
      rentalPrice: double.parse(json['rental_price'].toString()),
      status: json['status'] ?? false,
      availabilityStartDate: DateTime.parse(json['availability_startDate']),
      availabilityEndDate: DateTime.parse(json['availability_endDate']),
      expirationDate: DateTime.parse(json['expiration_date']),
      category: Category.fromJson(json['category']),
      rentalTerms: json['rental_terms'],
      location: json['location'],
      extraOptions: json['extra_options'],
      proprietaire: User.fromJson(json['proprietaire']),
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return {
      'id': id,
      'title': title,
      'description': description,
      'pictures': pictures,
      'rental_price': rentalPrice,
      'status': status,
      'availability_startDate': formatter.format(availabilityStartDate),
      'availability_endDate': formatter.format(availabilityEndDate),
      'expiration_date': formatter.format(expirationDate),
      'category': category.toJson(),
      'rental_terms': rentalTerms,
      'location': location,
      'extra_options': extraOptions,
      'proprietaire': proprietaire.toJson(),
    };
  }
}

class Category {
  final String id;
  final String wording;
  final bool isDeleted;

  Category({
    required this.id,
    required this.wording,
    this.isDeleted = false,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      wording: json['wording'],
      isDeleted: json['is_deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wording': wording,
      'is_deleted': isDeleted,
    };
  }
}
