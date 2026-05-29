/// Represents an emergency service location (police post, hospital, fire station, etc.)
class EmergencyService {
  final String id;
  final String name;
  final String type; // police, hospital, fire, ambulance
  final String phone;
  final String address;
  final String? hours;
  final List<String> servicesOffered;
  final double latitude;
  final double longitude;
  final double distanceKm; // mock distance

  const EmergencyService({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.address,
    this.hours,
    this.servicesOffered = const [],
    required this.latitude,
    required this.longitude,
    this.distanceKm = 0.0,
  });
}
