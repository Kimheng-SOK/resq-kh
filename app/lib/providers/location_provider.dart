import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Model ---

class LocationState {
  final String city;
  final String district;
  final double lat;
  final double lng;

  const LocationState({
    required this.city,
    required this.district,
    required this.lat,
    required this.lng,
  });
}

// --- Notifier ---

class LocationNotifier extends Notifier<LocationState> {
  @override
  LocationState build() {
    // Mock GPS: hard-coded to BKK1, Phnom Penh
    return const LocationState(
      city: 'Phnom Penh',
      district: 'BKK1',
      lat: 11.5564,
      lng: 104.9282,
    );
  }
}

// --- Provider ---

final locationProvider = NotifierProvider<LocationNotifier, LocationState>(
  LocationNotifier.new,
);