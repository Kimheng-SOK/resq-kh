import 'package:flutter/material.dart';
import '../../core/theme/app_color.dart';

class ServiceUtils {
  ServiceUtils._();

  /// Returns the icon for the given service type.
  static IconData iconForType(String type) {
    switch (type) {
      case 'police':
        return Icons.local_police_rounded;
      case 'hospital':
        return Icons.local_hospital_rounded;
      case 'fire':
      case 'fire_station':
        return Icons.local_fire_department_rounded;
      case 'ambulance':
        return Icons.airport_shuttle_rounded;
      case 'helpline':
        return Icons.phone_in_talk_rounded;
      case 'disaster':
        return Icons.warning_rounded;
      case 'nearby':
        return Icons.place_rounded;
      case 'general':
        return Icons.people_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  /// Returns the display color for the given service type.
  static Color colorForType(String type) {
    switch (type) {
      case 'police':
        return AppColors.police;
      case 'hospital':
        return AppColors.hospital;
      case 'fire':
      case 'fire_station':
        return AppColors.fire;
      case 'ambulance':
        return AppColors.ambulance;
      case 'helpline':
        return AppColors.success;
      case 'disaster':
        return AppColors.warning;
      case 'nearby':
        return AppColors.nearby;
      case 'general':
        return AppColors.general;
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
      case 'fire_station':
        return 'Fire Station';
      case 'ambulance':
        return 'Ambulance';
      case 'helpline':
        return 'Helpline';
      case 'disaster':
        return 'Disaster Response';
      case 'nearby':
        return 'Nearby Places';
      case 'general':
        return 'General Contact';
      default:
        return 'Service';
    }
  }
}
