import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserModel {
  final String id;
  final String fullName;
  final String? email;
  final String phoneNumber;
  final bool? isVerified;
  final String? bloodType;
  final String? allergies;
  final String preferred_language;
  final String dark_mode;
  final DateTime created_at;
  final DateTime updated_at;

  UserModel({
    required this.id,
    required this.fullName,
    this.email,
    required this.phoneNumber,
    this.isVerified,
    this.bloodType,
    this.allergies,
    required this.preferred_language,
    required this.dark_mode,
    required this.created_at,
    required this.updated_at,
  });
}
