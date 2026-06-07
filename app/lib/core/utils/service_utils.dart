import 'package:flutter/material.dart';
import '../../core/theme/app_color.dart';

/// Shared service-type helpers used by map markers, contacts, and detail screens.
class ServiceUtils {
  ServiceUtils._();

  /// Returns an icon that represents the given service type.
  static IconData iconForType(String type) {
    switch (type) {
      case 'police':
        return Icons.local_police_rounded;
      case 'hospital':
        return Icons.local_hospital_rounded;
      case 'fire':
        return Icons.local_fire_department_rounded;
      case 'ambulance':
        return Icons.airport_shuttle_rounded;
      case 'helpline':
        return Icons.phone_in_talk_rounded;
      case 'disaster':
        return Icons.warning_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  /// Returns a display color for the given service type.
  static Color colorForType(String type) {
    switch (type) {
      case 'police':
        return AppColors.police;
      case 'hospital':
        return AppColors.hospital;
      case 'fire':
        return AppColors.fire;
      case 'ambulance':
        return AppColors.ambulance;
      case 'helpline':
        return AppColors.success;
      case 'disaster':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  /// Returns a human-readable label for the given service type.
  static String labelForType(String type) {
    switch (type) {
      case 'police':
        return 'Police';
      case 'hospital':
        return 'Hospital';
      case 'fire':
        return 'Fire Station';
      case 'ambulance':
        return 'Ambulance';
      case 'helpline':
        return 'Helpline';
      case 'disaster':
        return 'Disaster Response';
      default:
        return 'Service';
    }
  }
}
