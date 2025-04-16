// lib/features/auth/models/user.dart
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? birthdate;
  final Role? role;
  final String? civility;
  final String? city;
  final Country? country;
  final String? department;
  final String? zipCode;
  final String? mainAddress;
  final String? secondaryAddress;
  final String? typeCompte;
  final String? photoProfil;
  final String? userCode;
  final bool isDeleted;
  final bool isNotificationActif;
  final bool isActivate;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.birthdate,
    this.role,
    this.civility,
    this.city,
    this.country,
    this.department,
    this.zipCode,
    this.mainAddress,
    this.secondaryAddress,
    this.typeCompte,
    this.photoProfil,
    this.userCode,
    this.isDeleted = false,
    this.isNotificationActif = true,
    this.isActivate = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['id'] ?? '',
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        email: json['email'] ?? '',
        phoneNumber: json['phone_number'] ?? '',
        birthdate: json['birthdate'],  // Peut être null
        role: json['role'] != null ? Role.fromJson(json['role']) : null,
        civility: json['civility'] ?? '',
        city: json['city'] ?? '',
        // Voici la correction principale
        country: json['country'] != null ? Country.fromJson(json['country']) : null,
        department: json['department'] ?? '',
        zipCode: json['zip_code'] ?? '',
        mainAddress: json['main_address'] ?? '',
        secondaryAddress: json['secondary_address'] ?? '',
        typeCompte: json['type_compte'] ?? '',
        photoProfil: json['photo_profil'] ?? '',  // Peut être null
        userCode: json['user_code'] ?? '',
        isDeleted: json['is_deleted'] ?? false,
        isNotificationActif: json['is_notification_actif'] ?? true,
        isActivate: json['is_active'] ?? true,
      );
    } catch (e) {
      print('Error parsing User from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'birthdate': birthdate,
      'role': role?.toJson(),
      'civility': civility,
      'city': city,
      // 'country': country?.toJson(),
      'department': department,
      'zip_code': zipCode,
      'main_adress': mainAddress,
      'secondary_adress': secondaryAddress,
      'type_compte': typeCompte,
      'photo_profil': photoProfil,
      'user_code': userCode,
      'is_deleted': isDeleted,
      'is_notification_actif': isNotificationActif,
      'is_activate': isActivate,
    };
  }
}

class Role {
  final String id;
  final String wording;
  final bool isDeleted;

  Role({
    required this.id,
    required this.wording,
    this.isDeleted = false,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
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

class Country {
  final String id;
  final String wording;  // Changé de 'name' à 'wording'
  final String code;     // Ajouté car présent dans l'API
  final bool isDeleted;

  Country({
    required this.id,
    required this.wording,
    required this.code,
    this.isDeleted = false,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? '',
      wording: json['wording'] ?? '',
      code: json['code'] ?? '',
      isDeleted: json['is_deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wording': wording,
      'code': code,
      'is_deleted': isDeleted,
    };
  }
}